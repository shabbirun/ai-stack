-- Run this in Supabase Dashboard → SQL Editor
-- Or apply via: supabase db push (if using Supabase CLI)

-- supabase/migrations/001_initial.sql

-- Profiles (auto-created on signup via trigger)
create table profiles (
  id uuid primary key references auth.users on delete cascade,
  is_admin boolean not null default false,
  has_paid boolean not null default false,
  stripe_customer_id text,
  email text,
  created_at timestamptz not null default now()
);

alter table profiles enable row level security;
create policy "Users can read own profile" on profiles
  for select using (auth.uid() = id);
create policy "Service role can manage profiles" on profiles
  for all using (true);

-- Trigger: auto-create profile on signup
create or replace function handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into profiles (id, email)
  values (new.id, new.email)
  on conflict (id) do update set email = new.email;
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure handle_new_user();

-- Modules
create table modules (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  "order" integer not null default 0,
  created_at timestamptz not null default now()
);

alter table modules enable row level security;
create policy "Authenticated users can read modules" on modules
  for select using (auth.role() = 'authenticated');
create policy "Service role can manage modules" on modules
  for all using (true);

-- Lessons
create table lessons (
  id uuid primary key default gen_random_uuid(),
  module_id uuid not null references modules on delete cascade,
  title text not null,
  youtube_url text,
  content text not null default '',
  "order" integer not null default 0,
  created_at timestamptz not null default now()
);

alter table lessons enable row level security;
create policy "Authenticated users can read lessons" on lessons
  for select using (auth.role() = 'authenticated');
create policy "Service role can manage lessons" on lessons
  for all using (true);

-- Lesson attachments
create table lesson_attachments (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid not null references lessons on delete cascade,
  file_name text not null,
  storage_path text not null,
  created_at timestamptz not null default now()
);

alter table lesson_attachments enable row level security;
create policy "Authenticated users can read attachments" on lesson_attachments
  for select using (auth.role() = 'authenticated');
create policy "Service role can manage attachments" on lesson_attachments
  for all using (true);

-- Lesson progress
create table lesson_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users on delete cascade,
  lesson_id uuid not null references lessons on delete cascade,
  completed_at timestamptz not null default now(),
  unique (user_id, lesson_id)
);

alter table lesson_progress enable row level security;
create policy "Users can manage own progress" on lesson_progress
  for all using (auth.uid() = user_id);

-- Comments
create table comments (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid not null references lessons on delete cascade,
  user_id uuid not null references auth.users on delete cascade,
  parent_id uuid references comments on delete cascade,
  content text not null,
  created_at timestamptz not null default now()
);

alter table comments enable row level security;
create policy "Authenticated users can read comments" on comments
  for select using (auth.role() = 'authenticated');
create policy "Users can insert own comments" on comments
  for insert with check (auth.uid() = user_id);
create policy "Users can delete own comments" on comments
  for delete using (auth.uid() = user_id);
create policy "Service role can delete any comment" on comments
  for delete using (true);

-- Lesson requests
create table lesson_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users on delete cascade,
  title text not null,
  description text not null,
  created_at timestamptz not null default now()
);

alter table lesson_requests enable row level security;
create policy "Authenticated users can read requests" on lesson_requests
  for select using (auth.role() = 'authenticated');
create policy "Users can insert own requests" on lesson_requests
  for insert with check (auth.uid() = user_id);

-- Supabase Storage bucket for attachments
insert into storage.buckets (id, name, public)
  values ('attachments', 'attachments', false)
  on conflict do nothing;

create policy "Authenticated users can read attachment files" on storage.objects
  for select using (bucket_id = 'attachments' and auth.role() = 'authenticated');
create policy "Service role can manage attachment files" on storage.objects
  for all using (bucket_id = 'attachments');
