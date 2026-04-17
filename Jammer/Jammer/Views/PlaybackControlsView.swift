//
//  PlaybackControlsView.swift
//  Jammer
//
//  Created on 2026-01-26.
//

import SwiftUI

/// Playback controls with play/pause and skip buttons
struct PlaybackControlsView: View {
    let manager: MusicPlaybackManager

    var body: some View {
        HStack(spacing: 48) {
            // Previous track button
            Button {
                Task {
                    try? await manager.skipToPrevious()
                }
            } label: {
                Image(systemName: "backward.fill")
                    .font(.system(size: 28))
            }
            .buttonStyle(.plain)
            .foregroundStyle(.primary)

            // Play/Pause button
            Button {
                if manager.isPlaying {
                    manager.pause()
                } else {
                    Task {
                        try? await manager.play()
                    }
                }
            } label: {
                Image(systemName: manager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 64))
            }
            .buttonStyle(.plain)
            .foregroundStyle(.primary)

            // Next track button
            Button {
                Task {
                    try? await manager.skipToNext()
                }
            } label: {
                Image(systemName: "forward.fill")
                    .font(.system(size: 28))
            }
            .buttonStyle(.plain)
            .foregroundStyle(.primary)
        }
        .sensoryFeedback(.impact, trigger: manager.isPlaying)
    }
}

#Preview {
    PlaybackControlsView(manager: MusicPlaybackManager())
}
