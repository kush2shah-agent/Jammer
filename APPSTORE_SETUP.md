# App Store Connect Configuration Required

This document outlines the capabilities and settings you need to configure in your Apple Developer Portal and App Store Connect for the Jammer app.

## Apple Developer Portal Configuration

### 1. App ID Capabilities

Navigate to your App ID in the Apple Developer Portal and enable the following capabilities:

#### Required Capabilities:

- **MusicKit** (`com.apple.developer.musickit`)
  - Purpose: Access Apple Music catalog and user's music library
  - Required for core app functionality

- **WeatherKit** (`com.apple.developer.weatherkit`)
  - Purpose: Provide weather-based music recommendations
  - Required for context-aware features

- **Push Notifications** (`aps-environment`)
  - Purpose: Remote notifications for updates
  - Already configured in entitlements

- **iCloud** (`com.apple.developer.icloud-services`)
  - Services: CloudKit
  - Purpose: Data synchronization across devices
  - Already configured in entitlements

#### Background Modes:

- **Audio** - Allows audio playback to continue when app is in background
- **Remote notifications** - For push notification handling

### 2. Provisioning Profile

After enabling the above capabilities:
1. Regenerate your development and distribution provisioning profiles
2. Download the updated profiles
3. Install them in Xcode

## Project Configuration Summary

### Deployment Target
- **Minimum iOS Version**: 17.0
- **Build SDK**: iOS 26.0
- **Rationale**: Maintains compatibility with iOS 17+ devices while leveraging iOS 26 features where available

### Privacy Permissions (Info.plist)

The following privacy descriptions have been configured:

1. **NSAppleMusicUsageDescription**
   - "We require access to your Apple Music data to let you interact with your library and use the app to control and play music."

2. **NSLocationWhenInUseUsageDescription**
   - "We use your location to provide weather-based music recommendations and enhance your listening experience with context-aware features."

3. **NSWeatherUsageDescription**
   - "We use weather information to provide weather-based music recommendations and enhance your listening experience."

### Supported Orientations

- **iPhone**: Portrait only (locked)
- **iPad**: All orientations (Portrait, Portrait Upside Down, Landscape Left, Landscape Right)

## Testing Checklist

Before submitting to App Store:

- [ ] Verify MusicKit capability is active in provisioning profile
- [ ] Verify WeatherKit capability is active in provisioning profile
- [ ] Test on device running iOS 17.0 (minimum supported version)
- [ ] Test on device running iOS 26.0 (latest features)
- [ ] Verify location permission prompt appears when needed
- [ ] Verify weather permission prompt appears when needed
- [ ] Verify Apple Music permission prompt appears when needed
- [ ] Test background audio playback
- [ ] Test orientation lock on iPhone (portrait only)
- [ ] Test orientation flexibility on iPad (all orientations)

## Important Notes

1. **WeatherKit**: Requires a paid Apple Developer Program membership and may have usage limits. Review Apple's WeatherKit pricing and usage guidelines.

2. **MusicKit**: Users must have an active Apple Music subscription to access full catalog features. The app should gracefully handle users without subscriptions.

3. **Location Services**: The app requests "When In Use" permission only. Consider user privacy and explain the value proposition clearly before requesting permission.

4. **Background Audio**: Ensure proper audio session configuration in code to maintain playback in background mode.

## Next Steps

1. Log in to [Apple Developer Portal](https://developer.apple.com)
2. Navigate to Certificates, Identifiers & Profiles
3. Select your App ID (com.kushs.Jammer)
4. Enable the capabilities listed above
5. Regenerate and download provisioning profiles
6. Return to Xcode and verify all capabilities are properly configured
