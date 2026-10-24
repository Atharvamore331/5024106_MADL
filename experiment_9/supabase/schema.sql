-- Run in the Supabase SQL Editor for this sample.
create table if not exists public.students (
  id integer primary key,
  name text not null,
  course text not null
);

alter table public.students enable row level security;

-- Demo-only anonymous policies. Use authenticated, narrower policies in real apps.
drop policy if exists "demo students readable" on public.students;
drop policy if exists "demo students insertable" on public.students;
drop policy if exists "demo students deletable" on public.students;

create policy "demo students readable" on public.students
  for select to anon using (true);
create policy "demo students insertable" on public.students
  for insert to anon with check (true);
create policy "demo students deletable" on public.students
  for delete to anon using (true);
