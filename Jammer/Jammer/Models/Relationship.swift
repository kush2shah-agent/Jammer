//
//  Relationship.swift
//  Jammer
//
//  Created on 2026-01-25.
//

import Foundation

/// Represents relationships between tracks (samples, covers, remixes, etc.)
struct Relationship: Codable, Sendable, Hashable {
    /// Relationship type (e.g., "samples", "cover", "remix", "sampled-by")
    let type: String

    /// Related track title
    let targetTrack: String

    /// Related artist name
    let targetArtist: String

    /// Optional additional context or description
    let description: String?

    init(type: String, targetTrack: String, targetArtist: String, description: String? = nil) {
        self.type = type
        self.targetTrack = targetTrack
        self.targetArtist = targetArtist
        self.description = description
    }
}
