alter table profiles
  add column if not exists full_name text,
  add column if not exists bio text;

create policy "Users can update own profile" on profiles
  for update using (auth.uid() = id)
  with check (auth.uid() = id);
