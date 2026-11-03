// Service Worker: hält die App offline verfügbar.
// Bei jedem Update die Versionsnummer erhöhen, damit alle Geräte die neue Version holen.
const CACHE = "planer-v8";
const SHELL = ["./", "./index.html", "./config.js", "./manifest.webmanifest", "./icon-192.png", "./icon-512.png", "./apple-touch-icon.png"];
self.addEventListener("install", e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)).then(() => self.skipWaiting()));
});
self.addEventListener("activate", e => {
  e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k !== CACHE && k !== "planer-fonts").map(k => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener("fetch", e => {
  const req = e.request;
  if(req.method !== "GET") return;
  const u = new URL(req.url);
  const shellFile = /\/(index\.html|config\.js|manifest\.webmanifest|icon-192\.png|icon-512\.png|apple-touch-icon\.png)?$/.test(u.pathname);
  if(u.origin === location.origin && (req.mode === "navigate" || shellFile)){
    // Sofort aus dem Speicher, im Hintergrund aktualisieren
    e.respondWith(caches.open(CACHE).then(async c => {
      const hit = await c.match(req, { ignoreSearch: true }) || (req.mode === "navigate" ? await c.match("./index.html") : undefined);
      const net = fetch(req).then(r => { if(r.ok) c.put(req, r.clone()); return r; }).catch(() => hit);
      return hit || net;
    }));
    return;
  }
  if(u.host === "fonts.googleapis.com" || u.host === "fonts.gstatic.com"){
    e.respondWith(caches.open("planer-fonts").then(async c => {
      const hit = await c.match(req); if(hit) return hit;
      try { const r = await fetch(req); c.put(req, r.clone()); return r; } catch { return new Response("", { status: 504 }); }
    }));
  }
  // Supabase-Anfragen laufen immer direkt übers Netz
});
