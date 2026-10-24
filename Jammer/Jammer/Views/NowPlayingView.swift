//
//  NowPlayingView.swift
//  Jammer
//
//  Created on 2026-01-26.
//

import SwiftUI
import MusicKit

/// Main view displaying the currently playing track with album art and controls
struct NowPlayingView: View {
    @State private var playbackManager = MusicPlaybackManager()

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 24) {
                    Spacer(minLength: 40)

                    if playbackManager.authorizationStatus != .authorized {
                        authorizationView
                    } else if let song = playbackManager.currentSong {
                        trackView(for: song, in: geometry)
                    } else {
                        emptyStateView
                    }

                    Spacer(minLength: 40)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .task {
            await playbackManager.requestAuthorization()
            playbackManager.startObserving()
        }
    }

    // MARK: - Authorization View

    private var authorizationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "music.note.house")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            Text("Connect to Apple Music")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Jammer needs access to Apple Music to show what you're listening to.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                Task {
                    await playbackManager.requestAuthorization()
                }
            } label: {
                Text("Grant Access")
                    .font(.headline)
                    .frame(maxWidth: 200)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }

    // MARK: - Track View

    private func trackView(for song: Song, in geometry: GeometryProxy) -> some View {
        VStack(spacing: 20) {
            // Album artwork
            artworkView(for: song, in: geometry)

            // Track info
            trackInfoView(for: song)

            // Playback controls
            PlaybackControlsView(manager: playbackManager)
                .padding(.top, 8)
        }
        .padding(.horizontal)
    }

    private func artworkView(for song: Song, in geometry: GeometryProxy) -> some View {
        let artworkSize = Self.artworkSize(in: geometry.size)

        return Group {
            if let artwork = song.artwork {
                ArtworkImage(artwork, width: artworkSize, height: artworkSize)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.quaternary)
                    .frame(width: artworkSize, height: artworkSize)
                    .overlay {
                        Image(systemName: "music.note")
                            .font(.system(size: 64))
                            .foregroundStyle(.secondary)
                    }
            }
        }
    }

    private func trackInfoView(for song: Song) -> some View {
        VStack(spacing: 6) {
            Text(song.title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text(song.artistName)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(1)

            if let albumTitle = song.albumTitle {
                Text(albumTitle)
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Empty State View

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "music.note")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            Text("Nothing Playing")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Play something in Apple Music to see it here.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding()
    }

    // MARK: - Helpers

    /// Size artwork within the current container, including narrow and short windows.
    static func artworkSize(in container: CGSize) -> CGFloat {
        let width = container.width
        let height = container.height

        // Leave room for track info and controls
        let maxHeight = height * 0.5

        // Use most of the width with padding
        let maxWidth = width - 48

        // Return the smaller of the two constraints, capped at reasonable sizes
        let size = min(maxWidth, maxHeight, 400)
        return max(size, 0)
    }
}

#Preview {
    NowPlayingView()
}
