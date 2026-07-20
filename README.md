# Watchlist App 🎬

Een iOS-app om films, series en documentaires op te slaan die je wilt kijken. Met automatische aanvulling via **TMDB** en filters op duur, continent, genre en streamingplatform.

---

## 📱 Functionaliteit
- ✅ Zoeken naar films/series/documentaires (automatische aanvulling via TMDB)
- ✅ Opslaan in je persoonlijke watchlist
- ✅ Status bijhouden: **To Watch / Watching / Watched**
- ✅ Filters:
  - Titel
  - Type (Film / Serie / Documentaire)
  - Status
  - Continent (Europa / Noord-Amerika / Azië)
  - Duur (minuten)
  - Streamingplatform (Netflix, Disney+, etc.)
- ✅ Sorteren op: Titel, Duur, Release Datum, Beoordeling
- ✅ Notities toevoegen per item
- ✅ Exporteren naar CSV
- ✅ Lokale opslag (data blijft staan)

---

## 🛠️ Installatie (voor Marije)

### Optie 1: Via TestFlight (Aanbevolen)
1. Ik stuur je een **TestFlight-uitnodiging** (zodra de app klaar is).
2. Open de uitnodiging op je **iPhone 16 Pro**.
3. Installeer de app via TestFlight.

### Optie 2: Via Xcode (Als je een Mac hebt)
1. Clone deze repository:
   ```bash
   git clone https://github.com/MarijeGit/MediabibliotheekMarije.git
   ```
2. Open `Watchlist/Watchlist.xcodeproj` in **Xcode**.
3. Selecteer je **iPhone 16 Pro** als target.
4. Klik op **▶ (Run)** om de app te installeren.

---

## ⚙️ Configuratie

### TMDB API Sleutel
1. Ga naar [TMDB API](https://www.themoviedb.org/settings/api).
2. Maak een account (als je dat nog niet hebt).
3. Vraag een **API-sleutel** aan (gratis).
4. Open `Watchlist/Watchlist/Utilities/Config.swift`.
5. Vervang `JE_TMDB_API_SLEUTEL_HIER` door je eigen sleutel:
   ```swift
   static let tmdbApiKey = "JOUW_TMDB_API_SLEUTEL"
   ```

---

## 📂 Projectstructuur
```
Watchlist/
├── Models/          # Data-modellen (MediaItem, etc.)
├── Services/        # API-calls en opslag (TMDBService, MediaStorage)
├── Views/           # SwiftUI-views (SearchView, ListView, etc.)
├── Utilities/       # Hulpbestanden (Config, Extensions)
└── Assets.xcassets/ # Afbeeldingen en app-icoon
```

---

## 🔧 Technische Details
- **Taal:** Swift (SwiftUI)
- **Minimale iOS-versie:** iOS 15.0
- **API:** [TMDB API v3](https://developers.themoviedb.org/3)
- **Opslag:** UserDefaults (voor kleine datasets)

---

## 📝 Feedback Geven
Als je de app test, kun je me laten weten:
- Wat **werkt goed** ✅
- Wat **niet werkt** ❌
- Wat je **wilt toevoegen** 💡

**Voorbeeld:**
> "De zoekfunctie werkt perfect! Maar ik mis een filter voor 'Genre'."

---

## 🚀 Toekomstige Uitbreidingen (optioneel)
- [ ] Dark Mode
- [ ] iCloud Sync (tussen apparaten)
- [ ] Widget voor startscherm
- [ ] Notificaties (herinneringen)
- [ ] Import van CSV
- [ ] Meerdere talen (NL/EN)

---

## 📄 Licentie
Deze app is **privé** en alleen bedoeld voor persoonlijk gebruik.

---

## 🙋 Vragen?
Stuur me een bericht als je hulp nodig hebt!
