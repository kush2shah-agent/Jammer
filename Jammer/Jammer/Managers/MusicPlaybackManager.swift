//
//  MusicPlaybackManager.swift
//  Jammer
//
//  Created on 2026-01-26.
//

import Foundation
import MusicKit
import Observation
import Combine

/// Manages Apple Music playback state and controls
@Observable
final class MusicPlaybackManager {
    // MARK: - Published State

    /// Currently playing track from Apple Music
    private(set) var currentTrack: Track?

    /// Whether music is currently playing
    private(set) var isPlaying: Bool = false

    /// Current MusicKit authorization status
    private(set) var authorizationStatus: MusicAuthorization.Status = .notDetermined

    // MARK: - Private Properties

    private let player = ApplicationMusicPlayer.shared
    private var stateObservationTask: Task<Void, Never>?
    private var queueObservationTask: Task<Void, Never>?

    // MARK: - Initialization

    init() {
        // Check current authorization status
        authorizationStatus = MusicAuthorization.currentStatus
    }

    deinit {
        stateObservationTask?.cancel()
        queueObservationTask?.cancel()
    }

    // MARK: - Authorization

    /// Request MusicKit authorization from the user
    @MainActor
    func requestAuthorization() async {
        let status = await MusicAuthorization.request()
        authorizationStatus = status
    }

    // MARK: - Playback Controls

    /// Start or resume playback
    func play() async throws {
        try await player.play()
    }

    /// Pause playback
    func pause() {
        player.pause()
    }

    /// Skip to the next track in the queue
    func skipToNext() async throws {
        try await player.skipToNextEntry()
    }

    /// Skip to the previous track in the queue
    func skipToPrevious() async throws {
        try await player.skipToPreviousEntry()
    }

    // MARK: - Observation

    /// Start observing player state changes
    func startObserving() {
        // Cancel any existing observation tasks
        stateObservationTask?.cancel()
        queueObservationTask?.cancel()

        // Observe playback state changes
        stateObservationTask = Task { @MainActor [weak self] in
            guard let self = self else { return }

            for await _ in self.player.state.objectWillChange.values {
                guard !Task.isCancelled else { break }
                self.updatePlaybackState()
            }
        }

        // Initial state update
        Task { @MainActor [weak self] in
            self?.updatePlaybackState()
        }
    }

    /// Stop observing player state changes
    func stopObserving() {
        stateObservationTask?.cancel()
        queueObservationTask?.cancel()
        stateObservationTask = nil
        queueObservationTask = nil
    }

    // MARK: - Private Methods

    @MainActor
    private func updatePlaybackState() {
        isPlaying = player.state.playbackStatus == .playing

        // Get current track from queue
        if let currentEntry = player.queue.currentEntry {
            // We don't use Track directly since the queue provides Song
            // The view will use currentSong instead
            currentTrack = nil
        } else {
            currentTrack = nil
        }
    }

    /// Get the current queue entry for display purposes
    @MainActor
    var currentEntry: ApplicationMusicPlayer.Queue.Entry? {
        player.queue.currentEntry
    }

    /// Get the current song if playing
    @MainActor
    var currentSong: Song? {
        guard let entry = player.queue.currentEntry else { return nil }
        switch entry.item {
        case .song(let song):
            return song
        default:
            return nil
        }
    }
}
