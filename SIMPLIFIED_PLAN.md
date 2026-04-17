# Jammer - Simplified MVP Plan

## Goal
Build a basic iOS app that plays music from Apple Music with simple playback controls.

**Target:** iOS 17.0+
**Scope:** Minimal viable product - just music playback, no metadata enrichment yet

## What We're Building

A single-screen app that:
1. Requests MusicKit authorization
2. Shows currently playing track from Apple Music
3. Displays album artwork
4. Provides basic playback controls (play/pause, skip forward/back)
5. Shows track info (title, artist, album)

## What We're NOT Building (Yet)

- ❌ MusicBrainz metadata enrichment
- ❌ Fact cards
- ❌ Context logging (location/weather)
- ❌ Caching
- ❌ Complex UI layouts
- ❌ Settings or additional screens

## Current State

**Completed:**
- ✅ Project configuration (iOS 17.0 target, MusicKit entitlements)
- ✅ Base models created (has build errors - needs fixing)

**Build Issues to Fix:**
- Models using iOS 18+ Testing framework (needs XCTest instead)
- Model import/dependency issues in EnrichedTrack.swift

## Implementation Plan

### Phase 1: Fix Build Errors (Current Priority)

**Task 1.1: Fix ModelsTests.swift**
- Replace `import Testing` with `import XCTest`
- Convert from `@Test` syntax to XCTest `func test*()` format
- Update assertions to XCTest style
- Ensure tests compile and run

**Task 1.2: Fix EnrichedTrack.swift Import Issues**
- Verify all model files are in correct location
- Add proper imports if needed
- Fix Codable/Hashable conformance issues
- Ensure project builds successfully

**Verification:**
- `xcodebuild -project Jammer/Jammer.xcodeproj -scheme Jammer -destination 'platform=iOS Simulator,name=iPhone 15' build` succeeds
- Tests run successfully

---

### Phase 2: Basic MusicKit Integration

**Task 2.1: Create MusicPlaybackManager**

Create `Jammer/Jammer/Managers/MusicPlaybackManager.swift`:

```swift
import MusicKit
import Observation

@Observable
final class MusicPlaybackManager {
    // State
    var currentTrack: Track?
    var isPlaying: Bool = false
    var authorizationStatus: MusicAuthorization.Status = .notDetermined

    private let player = ApplicationMusicPlayer.shared

    // Authorization
    func requestAuthorization() async {
        let status = await MusicAuthorization.request()
        authorizationStatus = status
    }

    // Playback controls
    func play() async throws {
        try await player.play()
        isPlaying = true
    }

    func pause() {
        player.pause()
        isPlaying = false
    }

    func skipToNext() async throws {
        try await player.skipToNextEntry()
    }

    func skipToPrevious() async throws {
        try await player.skipToPreviousEntry()
    }

    // Observer for current track
    func startObserving() {
        Task {
            for await state in player.state.values {
                await MainActor.run {
                    currentTrack = player.queue.currentEntry?.item
                    isPlaying = state.playbackStatus == .playing
                }
            }
        }
    }
}
```

**Tests:**
- Test authorization flow
- Test playback state updates
- Mock MusicKit player for unit tests

---

**Task 2.2: Create Basic UI**

Create `Jammer/Jammer/Views/NowPlayingView.swift`:

```swift
import SwiftUI
import MusicKit

struct NowPlayingView: View {
    @State private var playbackManager = MusicPlaybackManager()

    var body: some View {
        VStack(spacing: 20) {
            if playbackManager.authorizationStatus != .authorized {
                // Authorization prompt
                authorizationView
            } else if let track = playbackManager.currentTrack {
                // Currently playing
                trackView(track)
            } else {
                // Empty state
                emptyStateView
            }
        }
        .task {
            await playbackManager.requestAuthorization()
            playbackManager.startObserving()
        }
    }

    private var authorizationView: some View {
        VStack(spacing: 16) {
            Text("Connect to Apple Music")
                .font(.title2)
            Button("Grant Access") {
                Task {
                    await playbackManager.requestAuthorization()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func trackView(_ track: Track) -> some View {
        VStack(spacing: 16) {
            // Album artwork
            if let artwork = track.artwork {
                ArtworkImage(artwork, width: 300, height: 300)
                    .cornerRadius(8)
            }

            // Track info
            VStack(spacing: 4) {
                Text(track.title)
                    .font(.title2)
                    .bold()
                Text(track.artistName)
                    .font(.body)
                    .foregroundStyle(.secondary)
                if let albumTitle = track.albumTitle {
                    Text(albumTitle)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }

            // Playback controls
            PlaybackControlsView(manager: playbackManager)
        }
        .padding()
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "music.note")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            Text("Play something in Apple Music")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}
```

Create `Jammer/Jammer/Views/PlaybackControlsView.swift`:

```swift
import SwiftUI

struct PlaybackControlsView: View {
    let manager: MusicPlaybackManager

    var body: some View {
        HStack(spacing: 40) {
            Button {
                Task {
                    try? await manager.skipToPrevious()
                }
            } label: {
                Image(systemName: "backward.fill")
                    .font(.title)
            }

            Button {
                if manager.isPlaying {
                    manager.pause()
                } else {
                    Task {
                        try? await manager.play()
                    }
                }
            } label: {
                Image(systemName: manager.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title)
            }

            Button {
                Task {
                    try? await manager.skipToNext()
                }
            } label: {
                Image(systemName: "forward.fill")
                    .font(.title)
            }
        }
        .buttonStyle(.bordered)
    }
}
```

**Tests:**
- UI tests for authorization flow
- UI tests for playback controls
- Snapshot tests for layouts (optional)

---

**Task 2.3: Update App Entry Point**

Update `Jammer/Jammer/JammerApp.swift`:

```swift
import SwiftUI

@main
struct JammerApp: App {
    var body: some Scene {
        WindowGroup {
            NowPlayingView()
        }
    }
}
```

**Delete:** `ContentView.swift`, `Item.swift` (not needed for MVP)

---

### Phase 3: Testing & Verification

**Task 3.1: Manual Testing Checklist**

Test on simulator and device:
- [ ] App launches without crashes
- [ ] MusicKit authorization prompt appears
- [ ] Can grant/deny authorization
- [ ] If denied, shows appropriate message
- [ ] When authorized but nothing playing, shows empty state
- [ ] When music is playing in Apple Music, app shows track info
- [ ] Album artwork displays correctly
- [ ] Track title, artist, album display correctly
- [ ] Play button works (resumes playback)
- [ ] Pause button works (pauses playback)
- [ ] Skip forward works
- [ ] Skip backward works
- [ ] UI updates when track changes in Apple Music
- [ ] App works in portrait orientation
- [ ] No memory leaks or crashes

**Task 3.2: Automated Tests**

Create test suite:
- Unit tests for MusicPlaybackManager
- UI tests for authorization flow
- UI tests for playback controls
- Test coverage > 60%

**Task 3.3: Build & Run**

Verify on multiple devices/simulators:
- iPhone SE (smallest screen)
- iPhone 15 (standard)
- iPhone 15 Pro Max (largest)
- iPad (verify orientation flexibility)

---

## Success Criteria

✅ App builds and runs on iOS 17.0+ devices
✅ Can authorize MusicKit access
✅ Displays currently playing track from Apple Music
✅ Album artwork shows correctly
✅ Playback controls work (play/pause/skip)
✅ UI is responsive and doesn't crash
✅ No console errors or warnings
✅ Basic test coverage in place

## What's Next (Future Iterations)

After MVP is working:
1. Add metadata enrichment from MusicBrainz
2. Implement fact cards
3. Add context logging
4. Implement caching
5. Polish UI/UX
6. Add settings screen

---

## Technical Notes

**MusicKit Requirements:**
- User must have Apple Music subscription
- App requires MusicKit entitlement (already configured)
- Must configure MusicKit identifier in App Store Connect
- Testing requires real device or simulator with Apple ID signed in

**Dependencies:**
- No third-party dependencies
- Uses only native iOS frameworks:
  - MusicKit
  - SwiftUI
  - Foundation
  - XCTest (for testing)

**Deployment:**
- Minimum: iOS 17.0
- Target: iOS 26.0 (use latest features where available)
- Devices: iPhone (portrait only), iPad (all orientations)

---

## File Structure (After MVP Complete)

```
Jammer/
├── Jammer.xcodeproj/
├── Jammer/
│   ├── JammerApp.swift (updated)
│   ├── Managers/
│   │   └── MusicPlaybackManager.swift (new)
│   ├── Views/
│   │   ├── NowPlayingView.swift (new)
│   │   └── PlaybackControlsView.swift (new)
│   ├── Models/
│   │   ├── EnrichedTrack.swift (existing, for future use)
│   │   ├── Credit.swift (existing, for future use)
│   │   ├── RecordingInfo.swift (existing, for future use)
│   │   ├── Relationship.swift (existing, for future use)
│   │   └── Fact.swift (existing, for future use)
│   ├── Assets.xcassets/
│   ├── Jammer.entitlements
│   └── Info.plist
├── JammerTests/
│   ├── MusicPlaybackManagerTests.swift (new)
│   ├── ModelsTests.swift (existing, fixed)
│   └── ViewsTests.swift (new)
└── JammerUITests/
    └── PlaybackUITests.swift (new)
```

---

## Next Immediate Steps

1. ✅ Document this simplified plan
2. ⏳ Fix build errors in existing models
3. ⏳ Implement MusicPlaybackManager
4. ⏳ Create basic UI
5. ⏳ Test on device/simulator
6. ⏳ Iterate and polish

---

**Document Version:** 1.0
**Last Updated:** 2026-01-25
**Status:** Ready to implement
