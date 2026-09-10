import {createClient} from '@supabase/supabase-js';
const url=import.meta.env.VITE_SUPABASE_URL as string|undefined;
const key=import.meta.env.VITE_SUPABASE_ANON_KEY as string|undefined;
export const isCloud=Boolean(url&&key&&!url.includes('YOUR_PROJECT'));
export const supabase=isCloud?createClient(url!,key!):null;
