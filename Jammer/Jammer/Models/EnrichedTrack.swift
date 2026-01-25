//
//  EnrichedTrack.swift
//  Jammer
//
//  Created on 2026-01-25.
//

import Foundation

/// Main model combining Apple Music metadata with enriched MusicBrainz data
struct EnrichedTrack: Codable, Sendable, Hashable {
    // MARK: - Apple Music Properties

    /// Track title
    let title: String

    /// Artist name
    let artistName: String

    /// Album name
    let albumName: String

    /// Artwork URL from MusicKit
    let artworkURL: String?

    /// Track duration in seconds
    let duration: TimeInterval?

    /// International Standard Recording Code
    let isrc: String?

    /// MusicKit track identifier
    let musicKitTrackID: String

    // MARK: - Enriched MusicBrainz Data

    /// Personnel credits (producers, engineers, musicians)
    var credits: [Credit]

    /// Recording studio and location information
    var recordingInfo: RecordingInfo?

    /// Track relationships (samples, covers, remixes)
    var relationships: [Relationship]

    /// Generated displayable facts for UI presentation
    var facts: [Fact]

    init(
        title: String,
        artistName: String,
        albumName: String,
        artworkURL: String? = nil,
        duration: TimeInterval? = nil,
        isrc: String? = nil,
        musicKitTrackID: String,
        credits: [Credit] = [],
        recordingInfo: RecordingInfo? = nil,
        relationships: [Relationship] = [],
        facts: [Fact] = []
    ) {
        self.title = title
        self.artistName = artistName
        self.albumName = albumName
        self.artworkURL = artworkURL
        self.duration = duration
        self.isrc = isrc
        self.musicKitTrackID = musicKitTrackID
        self.credits = credits
        self.recordingInfo = recordingInfo
        self.relationships = relationships
        self.facts = facts
    }
}
