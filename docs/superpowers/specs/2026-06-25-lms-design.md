# LMS Design Spec
**Date:** 2026-06-25

## Overview

A self-hosted, Skool-inspired LMS with no community features. Students access course content (modules + lessons) behind a one-time Stripe payment. Lessons support YouTube embeds, WYSIWYG content, downloadable attachments, and threaded comments. Students can mark lessons complete and submit lesson requests. Admins manage all content via a built-in admin panel.

---

## 1. Architecture

```
DigitalOcean Droplet
└── Docker container: Next.js App Router
    ├── /app/(public)        → landing page, login, signup, payment
    ├── /app/(course)        → gated course content (middleware-protected)
    └── /app/admin           → admin panel (role-protected)

Supabase Cloud
├── Auth                     → email/password auth
├── Postgres                 → all app data
└── Storage                  → lesson attachments

Stripe
└── One-time checkout        → webhook sets has_paid = true on user profile
```

- Next.js middleware intercepts every `(course)` route, checks Supabase session + `has_paid` flag
- If no session → `/login`; if session but not paid → `/pay`
- Admin routes additionally check `is_admin = true`
- Stripe webhook hits `/api/stripe/webhook` (Next.js API route)

---

## 2. Data Model

```sql
-- Auto-created on signup via Supabase DB trigger
profiles (
  id              uuid PK FK → auth.users,
  is_admin        boolean DEFAULT false,
  has_paid        boolean DEFAULT false,
  stripe_customer_id text,
  created_at      timestamptz
)

modules (
  id              uuid PK,
  title           text,
  order           integer,
  created_at      timestamptz
)

lessons (
  id              uuid PK,
  module_id       uuid FK → modules,
  title           text,
  youtube_url     text nullable,
  content         text,        -- HTML from WYSIWYG
  order           integer,
  created_at      timestamptz
)

lesson_attachments (
  id              uuid PK,
  lesson_id       uuid FK → lessons,
  file_name       text,
  storage_path    text,        -- Supabase Storage path
  created_at      timestamptz
)

lesson_progress (
  id              uuid PK,
  user_id         uuid FK → auth.users,
  lesson_id       uuid FK → lessons,
  completed_at    timestamptz,
  UNIQUE(user_id, lesson_id)
)

comments (
  id              uuid PK,
  lesson_id       uuid FK → lessons,
  user_id         uuid FK → auth.users,
  parent_id       uuid FK → comments nullable,  -- null = top-level
  content         text,
  created_at      timestamptz
)

lesson_requests (
  id              uuid PK,
  user_id         uuid FK → auth.users,
  title           text,
  description     text,
  created_at      timestamptz
)
```

**Notes:**
- `lesson_progress` uses a unique constraint; marking complete = upsert, marking incomplete = delete
- Comments support 2 levels only: top-level + replies. Replies cannot be replied to.
- `is_admin` is set manually in the DB; no self-serve admin signup

---

## 3. Auth & Payment Flow

1. User signs up with email/password via Supabase Auth
2. DB trigger creates `profiles` row (`has_paid = false`, `is_admin = false`)
3. After login, middleware checks `has_paid`; unpaid users land on `/pay`
4. `/pay` page calls `/api/stripe/checkout` → creates Stripe Checkout session → redirects to Stripe
5. On success, Stripe fires `checkout.session.completed` to `/api/stripe/webhook`
6. Webhook sets `has_paid = true` and `stripe_customer_id` on the profile
7. User is redirected to `/dashboard`

No subscription or refund automation. Admin can manually revoke access by setting `has_paid = false`.

---

## 4. Core Features

### Course Navigation
- `/dashboard`: all modules as collapsible sections, each listing lessons with completion checkmarks
- Persistent sidebar across lesson views showing module/lesson tree
- Completion percentage shown per module and overall

### Lesson Page (`/lesson/[id]`)
- Title
- YouTube embed (if `youtube_url` set)
- WYSIWYG-rendered HTML content
- Downloadable attachments list
- "Mark complete / Mark incomplete" toggle (upserts/deletes `lesson_progress` row)
- Threaded comments section

### WYSIWYG Editor (admin only)
- Library: **Tiptap**
- Extensions: Bold, Italic, Underline, Headings (H1–H3), Bullet lists, Numbered lists, Blockquote, Code block, Links, Images
- Saves as HTML in `lessons.content`

### Comments
- Top-level comments with inline reply box (opened by "Reply" button)
- Replies rendered indented under parent
- 2 levels max — no reply-to-reply
- Users can delete their own comments; admin can delete any comment

### Lesson Requests (`/requests`)
- Form: title + description
- Below form: read-only list of all submitted requests (all users) for social proof
- Admin view at `/admin/requests` (same list, no status workflow)

---

## 5. Admin Panel

All routes under `/admin`, protected by `is_admin = true`.

### `/admin` — Dashboard
- Stats: total students, paid students, total lessons, recent lesson requests

### `/admin/modules` — Module Management
- List modules with drag-to-reorder (updates `order`)
- Create / rename / delete module
- Delete blocked if module has lessons

### `/admin/modules/[id]/lessons` — Lesson Management
- List lessons with drag-to-reorder
- Create / edit / delete lesson
- Lesson editor:
  - Title input
  - YouTube URL input (optional)
  - Tiptap WYSIWYG editor
  - Attachment uploader → Supabase Storage → row in `lesson_attachments`
  - Save / discard

### `/admin/requests` — Lesson Requests
- Table: student name, title, description, submitted date
- Read-only

### `/admin/students` — Student Management
- Table: email, joined date, lessons completed
- Manual revoke access (`has_paid = false`)

---

## 6. Deployment

### Droplet
- DigitalOcean Droplet, 2GB RAM minimum
- Docker + Docker Compose: Next.js container + Nginx container
- Nginx as reverse proxy with SSL termination (Let's Encrypt / Certbot)

### Files
- `Dockerfile` — multi-stage Next.js build
- `docker-compose.yml` — Next.js + Nginx services
- `.env` — secrets on the Droplet (not committed)
- `nginx.conf` — proxy config + SSL

### Deploy process
```bash
ssh user@droplet
git pull
docker compose up --build -d
```

### Environment Variables
```
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
STRIPE_SECRET_KEY
STRIPE_WEBHOOK_SECRET
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY
NEXT_PUBLIC_APP_URL
```

---

## Out of Scope
- Community / social feed
- Multiple courses / tiered pricing
- Student file uploads / homework submissions
- Email notifications
- CI/CD pipeline (manual deploy initially)
- Lesson request status workflow (admin response)
