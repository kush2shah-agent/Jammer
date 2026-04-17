# Jammer - Comprehensive Vision

## Overview

Jammer is an iOS app that enriches Apple Music playback with deep contextual metadata from MusicBrainz, displaying fascinating facts about currently playing tracks including credits, recording details, relationships to other music, and personal listening history.

**Core Concept:** Transform passive music listening into an engaging, informative experience by surfacing the stories behind the songs.

---

## The Problem

When listening to music on streaming services:
- Users rarely know who produced, engineered, or played on tracks
- Recording history (studio, location, date) is hidden
- Musical relationships (samples, covers, influences) are undiscovered
- Personal listening patterns go unnoticed
- Rich metadata exists but isn't accessible during playback

**Result:** Music becomes background noise instead of an engaging experience.

---

## The Vision

An app that automatically enriches every song you play with:

### 1. **Production Credits**
- "Produced by Rick Rubin at Shangri-La Studios, Malibu"
- "Mixed by Bob Clearmountain"
- "Mastered by Bernie Grundman"
- Session musicians and their instruments

### 2. **Recording Context**
- "Recorded at Abbey Road Studios, London in June 1967"
- "First take, captured live in one session"
- "Recorded on vintage analog equipment"

### 3. **Musical Relationships**
- "Sampled in 'Mo Money Mo Problems' by The Notorious B.I.G."
- "Cover of 'Respect' originally by Otis Redding (1965)"
- "Interpolates 'Canon in D' by Johann Pachelbel"

### 4. **Personal Context**
- "First time hearing this track"
- "You've played this 23 times in the past month"
- "Last heard 2 weeks ago in Brooklyn, rainy evening"
- Weather and location context (opt-in)

### 5. **Surprising Facts**
- "This song was initially rejected by 5 record labels"
- "Written in 15 minutes during a lunch break"
- "Features a 40-piece orchestra"
- "Legendary guitarist on track: Eddie Van Halen (uncredited)"

---

## User Experience

### Primary Flow

1. **User plays a song** in Apple Music (background or foreground)
2. **Jammer automatically detects** the track change
3. **App queries MusicBrainz** for enriched metadata (with intelligent caching)
4. **Generates prioritized facts** from the data (most interesting first)
5. **Displays facts as swipeable cards** below the album artwork
6. **User swipes through facts** while listening, discovering stories
7. **Facts auto-advance** every 6 seconds (unless user is actively swiping)

### Visual Design

```
┌─────────────────────────────┐
│                             │
│   ┌─────────────────────┐   │
│   │                     │   │
│   │   Album Artwork     │   │ ← Large, prominent
│   │   (300-360pt)       │   │
│   │                     │   │
│   └─────────────────────┘   │
│                             │
│  Track Title                │ ← Bold, clear
│  Artist Name                │ ← Secondary
│  Album Name                 │ ← Tertiary
│                             │
│  ┌───────────────────────┐  │
│  │ "Produced by          │  │ ← Swipeable fact card
│  │  Rick Rubin"          │  │   with material background
│  │                       │  │   Source: MusicBrainz
│  └───────────────────────┘  │
│  • • • ○ • • •             │ ← Page indicators
│                             │
│  ⏮  ⏯  ⏭                  │ ← Playback controls
│                             │
└─────────────────────────────┘
```

### Interaction Model

- **Vertical scroll:** Reveal fact cards, snap-to-top when scrolling back up
- **Horizontal swipe:** Navigate between fact cards
- **Pull-to-refresh:** Re-fetch metadata from MusicBrainz (force update)
- **Tap artwork:** Expand to full screen (future)
- **Tap fact:** Show detailed view with links (future)

---

## Technical Architecture

### Data Flow

```
Track Playing in Apple Music
  ↓
MusicPlaybackManager observes change (500ms debounce)
  ↓
MetadataService checks cache (SwiftData)
  ↓ (cache miss)
MusicBrainzClient queries by ISRC
  ↓ (fallback if no ISRC)
MusicBrainzClient fuzzy search by artist + title
  ↓
FactGenerator transforms raw metadata into displayable facts
  ↓
CacheService saves enriched data (JSON in SwiftData)
  ↓
NowPlayingView displays album art + swipeable fact cards
```

### Core Modules

**1. MusicPlaybackManager**
- Wraps MusicKit's ApplicationMusicPlayer
- Observes current track changes
- Provides playback controls
- Debounces rapid track changes (prevent API spam)
- Extracts: title, artist, album, ISRC, artwork, duration

**2. MetadataService**
- Coordinates metadata enrichment flow
- Checks cache before API calls
- Orchestrates MusicBrainzClient and FactGenerator
- Handles errors gracefully (fallback to basic data)
- Returns EnrichedTrack models

**3. MusicBrainzClient**
- Actor-based for thread safety
- Rate limiting: 1 request/second (RateLimiter)
- Primary: ISRC lookup (most accurate)
- Fallback: Fuzzy search by artist + title (score > 90)
- Includes: artist-credits, releases, tags, recording-rels
- Proper User-Agent string (MusicBrainz requirement)

**4. FactGenerator**
- Transforms raw MusicBrainz JSON into human-readable facts
- Priority system (1-5): samples/covers (5) → personnel (4) → credits (3)
- Smart text formatting: "May 1967" not "1967-05"
- Combines related credits: "Drums & Percussion: John Bonham"
- Filters duplicates and near-duplicates
- Generates 2-8 facts per track

**5. CacheService**
- SwiftData persistence layer
- Cache key: ISRC (preferred) or SHA256(artist|title)
- Stores JSON-encoded EnrichedTrack
- No TTL (metadata rarely changes)
- Instant cache hits (no loading)

**6. LocationManager** (Optional Feature)
- CoreLocation wrapper
- Requests "when in use" authorization
- Gets current coordinates
- City-level precision only (privacy)

**7. Context Logger** (Optional Feature)
- Opt-in feature (default: OFF)
- Logs ListeningSession with:
  - Track info, timestamp
  - Location (city-level)
  - Weather from WeatherKit
  - Play count, first/last heard
- Generates context facts:
  - "First time hearing this"
  - "Played 5 times this month"
  - "Last heard in Brooklyn, sunny 72°F"

### Data Models

**EnrichedTrack**
- Apple Music data: title, artist, album, artwork, duration, ISRC
- MusicBrainz data: credits[], recordingInfo, relationships[], facts[]

**Credit**
- name, role, instrument (optional)

**RecordingInfo**
- studioName, location, date (human-readable)

**Relationship**
- type (samples, cover, remix), targetTrack, targetArtist, description

**Fact**
- title, detail, priority (1-5), category, source

**CachedMetadata** (SwiftData)
- key (ISRC or hash), jsonData (EnrichedTrack), fetchedAt

**ListeningSession** (SwiftData)
- trackId, title, artist, playedAt, latitude/longitude, weather, context

---

## Key Features

### Phase 1: Foundation (MVP)
✅ Basic Apple Music playback integration
✅ Display currently playing track
✅ Album artwork and metadata
✅ Playback controls (play/pause/skip)

### Phase 2: Metadata Enrichment
- MusicBrainz API integration
- Fact generation and display
- Swipeable fact cards
- Priority-based fact ordering
- Smart caching

### Phase 3: Context & History
- Listening session logging (opt-in)
- Location context (city-level)
- Weather context via WeatherKit
- Play count and frequency tracking
- "First listen" / "Haven't heard in X weeks" facts

### Phase 4: Polish & Features
- Pull-to-refresh for metadata
- Auto-advancing fact cards
- Snap-to-top scroll behavior
- Loading states and shimmer effects
- Empty states and error handling
- Settings screen for preferences

### Phase 5: Advanced Features (Future)
- Search for tracks/artists in app
- Explore artist discography
- Deep links to Spotify/Apple Music
- Share facts to social media
- Collaborative listening sessions
- Music trivia game mode
- AR vinyl record visualization
- Integration with last.fm, Discogs

---

## Privacy & Ethics

### Privacy-First Design

1. **Local-Only Data**
   - All listening history stored on-device (SwiftData)
   - Never synced to cloud or sent to servers
   - No analytics or tracking
   - User can delete all data anytime

2. **Opt-In Context**
   - Location tracking: OFF by default
   - Weather tracking: OFF by default
   - Clear explanation of what's stored
   - Granular permissions

3. **Minimal Data Collection**
   - Location: City-level only, not precise coordinates
   - Weather: Current conditions only
   - No personal identifiers sent to MusicBrainz

4. **Transparent Sources**
   - Each fact shows source badge ("MusicBrainz")
   - Users know where data comes from
   - Respect MusicBrainz rate limits and guidelines

### Data Retention

- Cached metadata: Indefinite (static data)
- Listening sessions: User-controlled deletion
- Location data: Can be cleared per-session
- No server-side storage

---

## Technical Constraints

### API Limitations

**MusicBrainz:**
- Rate limit: 1 request/second
- No API key required (free, open)
- Must include User-Agent
- Respect server load

**MusicKit:**
- Requires Apple Music subscription
- Requires MusicKit entitlement
- Limited to signed-in Apple ID
- Can't access all track metadata (DRM restrictions)

**WeatherKit:**
- Free tier: 500K calls/month
- Requires Apple Developer account
- Location-dependent

### Platform Constraints

**iOS Requirements:**
- Minimum: iOS 17.0 (for MusicKit modern APIs)
- Target: iOS 26.0 (use latest features)
- Requires device testing (simulators limited for MusicKit)

**Device Support:**
- iPhone: Portrait only
- iPad: All orientations
- No macOS support (MusicKit limitations)

---

## Challenges & Solutions

### Challenge 1: ISRC Not Always Available
**Solution:** Fallback to fuzzy search by artist + title. Only accept high-confidence matches (score > 90). Show "Limited info" badge if no match.

### Challenge 2: MusicBrainz Rate Limiting
**Solution:** Implement RateLimiter actor with token bucket. Queue requests (max 10), timeout after 10s. Aggressive caching to minimize API calls.

### Challenge 3: Classical Music Overwhelming Credits
**Solution:** Limit to top 5 credits + "and 15 more". Smart role grouping (combine violin I, II, III into "Strings section").

### Challenge 4: Rapid Track Skipping
**Solution:** 500ms debounce in MusicPlaybackManager. Cancel in-flight requests when track changes. Prioritize cache hits.

### Challenge 5: Multiple Releases/Versions
**Solution:** Prefer original release by earliest date. Match album title from Apple Music if possible. Show release year in facts.

### Challenge 6: Network Failures
**Solution:** Check stale cache first. Retry once after 2s. Gracefully degrade to Apple Music data only. Never block UI.

### Challenge 7: App Backgrounding
**Solution:** Use background task API or cancel in-flight requests. Refetch metadata on foreground if needed.

---

## Success Metrics

### MVP Success (Phase 1)
- ✅ App launches and connects to Apple Music
- ✅ Displays currently playing track
- ✅ Playback controls work
- ✅ No crashes or blocking bugs

### Feature Success (Phase 2-3)
- 80%+ of popular tracks have enriched metadata
- Average 4+ facts per track
- Cache hit rate > 90% for repeat plays
- No API rate limit errors
- Sub-1s load time for cached tracks

### User Success (Phase 4+)
- Users discover surprising facts about familiar songs
- Session duration > 5 minutes (engaged, not passive)
- Users swipe through 3+ fact cards per track
- Positive app store reviews mentioning "learned something new"

---

## Roadmap

### v1.0 - MVP (Current)
- Basic playback integration
- Simple UI with controls
- Fix build errors and stability

### v1.1 - Metadata Enrichment
- MusicBrainz integration
- Fact generation
- Swipeable cards
- Caching

### v1.2 - Context & History
- Listening sessions
- Location/weather context
- Play count tracking
- Context facts

### v1.3 - Polish
- Pull-to-refresh
- Auto-advancing cards
- Improved error handling
- Settings screen

### v2.0 - Advanced Features
- In-app search
- Artist exploration
- Social sharing
- Trivia mode

### v3.0 - Platform Expansion
- Apple Watch complication
- Widgets for lock screen
- Siri integration
- CarPlay support (if feasible)

---

## Design Principles

1. **Information First:** Every element serves to inform and delight
2. **Non-Intrusive:** Works alongside Apple Music, doesn't replace it
3. **Privacy-Respecting:** Local storage, opt-in tracking, transparent data usage
4. **Beautiful Simplicity:** Clean UI, focus on content, minimal chrome
5. **Respect Rate Limits:** Good API citizenship with MusicBrainz
6. **Graceful Degradation:** Works even when APIs fail or data is missing
7. **Fast & Responsive:** Cache-first, instant loading for repeat plays
8. **Accessible:** VoiceOver support, dynamic type, high contrast modes

---

## Inspiration & References

**Apps:**
- Shazam: Music recognition and metadata display
- Genius: Lyrics and annotations
- SongStats: Listening history tracking
- Marvis Pro: Custom Apple Music interface

**Data Sources:**
- MusicBrainz: Open music encyclopedia
- Discogs: Music database and marketplace
- WhoSampled: Sample and cover tracking
- AllMusic: Album reviews and biographies

**Design:**
- Apple Music: Native iOS music playback
- Spotify: Clean metadata display
- Pocket Casts: Card-based information UI

---

## Open Questions

1. Should we support Spotify in addition to Apple Music?
2. How to handle podcasts (currently music-only)?
3. Should facts be user-editable/contributable?
4. Integration with MusicBrainz Picard for tagging?
5. Social features (share discoveries with friends)?
6. Offline mode (cache facts for offline playback)?

---

## Long-Term Vision

**Goal:** Make Jammer the essential companion app for music lovers who want to understand and appreciate the craft behind their favorite songs.

**Success looks like:**
- Users discover stories they never knew about familiar tracks
- Music becomes more engaging and meaningful
- Users contribute back to MusicBrainz (future)
- App becomes part of daily listening ritual
- Community forms around sharing musical discoveries

**The Ultimate Vision:**
Every song tells a story. Jammer helps you discover those stories, one track at a time.

---

**Document Version:** 1.0
**Last Updated:** 2026-01-25
**Status:** Vision Document - guides future development
