# AMR Project Management System V1

面向 AMR 项目交付的中文项目管理系统，覆盖项目总览、需求、技术验证、任务、风险、现场交付和项目移交。

## 本地运行

```bash
npm install
cp .env.example .env
npm run dev
```

未填写 Supabase 环境变量时自动使用演示数据。生产环境请在 Supabase SQL Editor 执行 `supabase/schema.sql`，再填写项目 URL 和 anon key。

## GitHub

```bash
git init
git add .
git commit -m "feat: AMR Project Management System V1"
git branch -M main
git remote add origin https://github.com/YOUR_NAME/amr-project-management.git
git push -u origin main
```

## Cloudflare Pages

在 Workers & Pages 中连接 GitHub 仓库，Framework preset 选择 Vite；Build command 为 `npm run build`，输出目录为 `dist`。在项目 Settings > Environment variables 中添加 `VITE_SUPABASE_URL` 和 `VITE_SUPABASE_ANON_KEY` 后重新部署。

## 下一步

当前 V1 提供完整页面流程、响应式界面、数据库模型与 RLS 权限基础。将演示数据替换为 Supabase CRUD、Storage 上传及邮件通知可作为 V1.1。
Deployment: Cloudflare Workers
