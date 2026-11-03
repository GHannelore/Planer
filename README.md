# Planer Uni & KBS

Kalender, Aufgaben, Prüfungen, Jahrespläne, Themenblöcke, Klassenspiegel und Brain Dump.
Läuft offline auf iPhone, iPad und Computer. Mit Internet gleicht sich alles über dein eigenes Supabase-Konto ab.

Einmalig brauchst du etwa 20 Minuten. Danach musst du nichts mehr einrichten.

---

## 1. Supabase einrichten (Datenabgleich)

1. Auf **supabase.com** ein kostenloses Konto erstellen → **New project**.
   Name z. B. `planer`, Region **Central EU (Frankfurt)** oder **Zurich**, falls angeboten. Ein Datenbank-Passwort wählen (wird nicht im Planer gebraucht).
2. Links **SQL Editor** → **New query** → den ganzen Inhalt von `setup.sql` einfügen → **Run**.
   Es sollte «Success» erscheinen.
3. Links **Authentication** → **Sign In / Providers** → **Email**:
   **Confirm email** ausschalten (sonst musst du zuerst einen Bestätigungslink anklicken).
4. **Project Settings** → **API** (bzw. **API Keys**): Notiere dir
   - **Project URL** (z. B. `https://abcdefgh.supabase.co`)
   - **anon / publishable key**

## 2. Auf GitHub Pages stellen

1. Auf **github.com** anmelden → oben rechts **+** → **New repository**.
   Name z. B. `planer`, **Public**, **Create repository**.
2. Auf der neuen Seite **uploading an existing file** anklicken und **alle Dateien aus diesem Ordner** hineinziehen
   (`index.html`, `sw.js`, `manifest.webmanifest`, `config.js`, die drei `.png`-Icons, `setup.sql`, `README.md`) → **Commit changes**.
3. Im Repository die Datei **config.js** öffnen → Stift-Symbol → Project URL und Key zwischen die Anführungszeichen eintragen → **Commit changes**.
4. **Settings** → **Pages** → bei «Branch» **main** und **/(root)** wählen → **Save**.
   Nach 1–2 Minuten erscheint oben die Adresse, z. B. `https://deinname.github.io/planer/`.

## 3. Konto erstellen und Daten übernehmen

1. Die Adresse am Computer öffnen → **Sync & Backup** → E-Mail und Passwort eingeben → **Konto erstellen**.
2. Zurück in Supabase: **Authentication** → **Sign In / Providers** → **Allow new users to sign up** ausschalten.
   So kann niemand sonst ein Konto in deinem Projekt anlegen.
3. Deine bisherigen Daten aus dem Planer auf claude.ai übernehmen:
   dort links **Daten exportieren** → Datei speichern → hier unter **Sync & Backup** → **Backup / Export importieren**.

## 4. Auf jedem Gerät installieren

- **iPhone / iPad:** Adresse in **Safari** öffnen → Teilen-Symbol → **Zum Home-Bildschirm**. Die App danach immer über das Symbol öffnen.
- **Windows / Mac mit Chrome oder Edge:** Installieren-Symbol rechts in der Adressleiste.
- **Mac mit Safari:** Ablage → **Zum Dock hinzufügen**.

Auf jedem Gerät einmal unter **Sync & Backup** mit demselben Konto anmelden.

---

## Gut zu wissen

- **Offline:** Alles, was du erfasst, wird sofort auf dem Gerät gespeichert. Unten links siehst du, ob noch Änderungen auf den Abgleich warten.
- **Gleichzeitige Änderungen:** Wird derselbe Eintrag auf zwei Geräten geändert, gilt die spätere Änderung.
- **Dateien** (auch Word, PowerPoint, PDF bis 50 MB) liegen auf dem Gerät, auf dem du sie hochgeladen hast. Die anderen Geräte laden sie beim ersten Öffnen mit Internet herunter und haben sie danach auch offline.
- **Backup:** Unter **Sync & Backup** kannst du jederzeit eine Sicherungsdatei aller Einträge herunterladen.
- **Kosten:** Der kostenlose Supabase-Plan reicht für diesen Zweck gut aus. Ein Projekt, das eine Woche lang gar nicht benutzt wird, pausiert Supabase. Du kannst es im Dashboard mit einem Klick wieder starten, deine Daten bleiben erhalten.
- **Updates:** Wenn du eine neue Version von `index.html` hochlädst, in `sw.js` die Zeile `planer-v1` auf `planer-v2` (usw.) ändern. Die Geräte holen die neue Version beim übernächsten Öffnen.
