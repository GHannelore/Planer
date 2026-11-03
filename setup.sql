-- Planer Uni & KBS: einmal im Supabase "SQL Editor" ausführen (New query → einfügen → Run).
-- Legt die Tabelle für deine Einträge und den Speicherordner für Dateien an.
-- Jede Zeile gehört genau einem Konto; niemand sonst kann sie lesen oder ändern.

create table if not exists public.items (
  user_id   uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id        text not null,
  data      jsonb not null default '{}'::jsonb,
  updated   bigint not null default 0,
  deleted   boolean not null default false,
  server_ts timestamptz not null default now(),
  primary key (user_id, id)
);
create index if not exists items_user_server_ts on public.items (user_id, server_ts);

alter table public.items enable row level security;
drop policy if exists "items lesen"    on public.items;
drop policy if exists "items anlegen"  on public.items;
drop policy if exists "items aendern"  on public.items;
drop policy if exists "items loeschen" on public.items;
create policy "items lesen"    on public.items for select using (auth.uid() = user_id);
create policy "items anlegen"  on public.items for insert with check (auth.uid() = user_id);
create policy "items aendern"  on public.items for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "items loeschen" on public.items for delete using (auth.uid() = user_id);

-- Zeitstempel des Servers bei jeder Änderung setzen (damit jedes Gerät weiss, was neu ist)
create or replace function public.planer_touch() returns trigger language plpgsql as $$
begin new.server_ts := clock_timestamp(); return new; end $$;
drop trigger if exists items_touch on public.items;
create trigger items_touch before insert or update on public.items
  for each row execute function public.planer_touch();

-- Privater Speicherordner für hochgeladene Dateien
insert into storage.buckets (id, name, public) values ('files', 'files', false)
  on conflict (id) do nothing;
drop policy if exists "planer dateien lesen"    on storage.objects;
drop policy if exists "planer dateien anlegen"  on storage.objects;
drop policy if exists "planer dateien aendern"  on storage.objects;
drop policy if exists "planer dateien loeschen" on storage.objects;
create policy "planer dateien lesen"    on storage.objects for select using (bucket_id = 'files' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "planer dateien anlegen"  on storage.objects for insert with check (bucket_id = 'files' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "planer dateien aendern"  on storage.objects for update using (bucket_id = 'files' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "planer dateien loeschen" on storage.objects for delete using (bucket_id = 'files' and (storage.foldername(name))[1] = auth.uid()::text);
