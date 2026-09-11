-- V1.2 security hardening and the data foundation for hierarchy/health features.
-- Run after schema.sql and migration_v1_1.sql.

alter table public.projects add column if not exists created_by uuid references public.profiles(id);
alter table public.projects alter column created_by set default auth.uid();

create or replace function public.is_project_member(target_project uuid)
returns boolean language sql stable security definer set search_path=public
as $$ select public.my_role()='admin' or exists(select 1 from public.project_members m where m.project_id=target_project and m.user_id=auth.uid()) $$;

create or replace function public.add_project_creator_as_member()
returns trigger language plpgsql security definer set search_path=public as $$
begin
  insert into public.project_members(project_id,user_id,member_role)
  values(new.id,coalesce(new.created_by,auth.uid()),case when public.my_role()='admin' then 'admin'::public.app_role else 'project_manager'::public.app_role end)
  on conflict do nothing;
  return new;
end $$;
drop trigger if exists project_creator_membership on public.projects;
create trigger project_creator_membership after insert on public.projects for each row execute function public.add_project_creator_as_member();

drop policy if exists "authenticated manage projects" on public.projects;
create policy "members read projects" on public.projects for select to authenticated using(public.is_project_member(id) or created_by=auth.uid());
create policy "authenticated create projects" on public.projects for insert to authenticated with check(created_by=auth.uid());
create policy "managers update projects" on public.projects for update to authenticated using(public.my_role() in ('admin','project_manager') and public.is_project_member(id)) with check(public.my_role() in ('admin','project_manager') and public.is_project_member(id));
create policy "managers delete projects" on public.projects for delete to authenticated using(public.my_role() in ('admin','project_manager') and public.is_project_member(id));

drop policy if exists "authenticated manage members" on public.project_members;
create policy "members read membership" on public.project_members for select to authenticated using(public.is_project_member(project_id));
create policy "managers add membership" on public.project_members for insert to authenticated with check(public.my_role() in ('admin','project_manager') and public.is_project_member(project_id));
create policy "managers change membership" on public.project_members for update to authenticated using(public.my_role() in ('admin','project_manager') and public.is_project_member(project_id)) with check(public.my_role() in ('admin','project_manager') and public.is_project_member(project_id));
create policy "managers remove membership" on public.project_members for delete to authenticated using(public.my_role() in ('admin','project_manager') and public.is_project_member(project_id));

do $$ declare t text; begin foreach t in array array['requirements','test_cases','tasks','risks','milestones','handover_items','attachments','comments'] loop
  execute format('drop policy if exists "authenticated manage %1$s" on public.%1$I',t);
  execute format('create policy "members read %1$s v12" on public.%1$I for select to authenticated using(public.is_project_member(project_id))',t);
  execute format('create policy "team insert %1$s v12" on public.%1$I for insert to authenticated with check(public.is_project_member(project_id) and public.my_role() in (''admin'',''project_manager'',''engineer''))',t);
  execute format('create policy "team update %1$s v12" on public.%1$I for update to authenticated using(public.is_project_member(project_id) and public.my_role() in (''admin'',''project_manager'',''engineer'')) with check(public.is_project_member(project_id))',t);
  execute format('create policy "managers delete %1$s v12" on public.%1$I for delete to authenticated using(public.is_project_member(project_id) and public.my_role() in (''admin'',''project_manager''))',t);
end loop; end $$;

create table if not exists public.regions(id uuid primary key default uuid_generate_v4(),name text not null,country_code text,created_at timestamptz default now());
create table if not exists public.factories(id uuid primary key default uuid_generate_v4(),project_id uuid not null references public.projects on delete cascade,region_id uuid references public.regions,name text not null,created_at timestamptz default now());
create table if not exists public.production_lines(id uuid primary key default uuid_generate_v4(),factory_id uuid not null references public.factories on delete cascade,name text not null,robot_count int not null default 0 check(robot_count>=0),operation_status text not null default '规划中',commissioned_at date,created_at timestamptz default now());
create table if not exists public.line_issues(id uuid primary key default uuid_generate_v4(),line_id uuid not null references public.production_lines on delete cascade,title text not null,description text,severity text not null default '一般' check(severity in ('一般','重要','严重影响生产')),status text not null default '待分析',progress int not null default 0 check(progress between 0 and 100),affected_robot_count int not null default 0 check(affected_robot_count>=0),discovered_at timestamptz not null default now(),due_date date,next_action text,resolved_at timestamptz,created_by uuid default auth.uid() references public.profiles,created_at timestamptz default now());
alter table public.regions enable row level security; alter table public.factories enable row level security; alter table public.production_lines enable row level security; alter table public.line_issues enable row level security;
create policy "authenticated read regions" on public.regions for select to authenticated using(true);
create policy "admins manage regions" on public.regions for all to authenticated using(public.my_role()='admin') with check(public.my_role()='admin');
create policy "members read factories" on public.factories for select to authenticated using(public.is_project_member(project_id));
create policy "managers manage factories" on public.factories for all to authenticated using(public.is_project_member(project_id) and public.my_role() in ('admin','project_manager')) with check(public.is_project_member(project_id) and public.my_role() in ('admin','project_manager'));
create policy "members read lines" on public.production_lines for select to authenticated using(exists(select 1 from public.factories f where f.id=factory_id and public.is_project_member(f.project_id)));
create policy "managers manage lines" on public.production_lines for all to authenticated using(exists(select 1 from public.factories f where f.id=factory_id and public.is_project_member(f.project_id) and public.my_role() in ('admin','project_manager'))) with check(exists(select 1 from public.factories f where f.id=factory_id and public.is_project_member(f.project_id) and public.my_role() in ('admin','project_manager')));
create policy "members read line issues" on public.line_issues for select to authenticated using(exists(select 1 from public.production_lines l join public.factories f on f.id=l.factory_id where l.id=line_id and public.is_project_member(f.project_id)));
create policy "team manage line issues" on public.line_issues for all to authenticated using(exists(select 1 from public.production_lines l join public.factories f on f.id=l.factory_id where l.id=line_id and public.is_project_member(f.project_id) and public.my_role() in ('admin','project_manager','engineer'))) with check(exists(select 1 from public.production_lines l join public.factories f on f.id=l.factory_id where l.id=line_id and public.is_project_member(f.project_id) and public.my_role() in ('admin','project_manager','engineer')));

create or replace view public.open_line_issues with (security_invoker=true) as
select i.id,i.title,i.severity,i.status,i.progress,i.discovered_at,i.affected_robot_count,i.next_action,p.name project_name,coalesce(r.name,'未设置') region_name,f.name factory_name,l.name line_name,l.robot_count line_robot_count
from public.line_issues i join public.production_lines l on l.id=i.line_id join public.factories f on f.id=l.factory_id join public.projects p on p.id=f.project_id left join public.regions r on r.id=f.region_id
where i.resolved_at is null and i.status not in ('已解决','已关闭');

comment on table public.line_issues is 'Health: green=0 open; orange=1-3 non-critical; red=>3 open or any production-critical issue.';
