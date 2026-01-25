//
//  Fact.swift
//  Jammer
//
//  Created on 2026-01-25.
//

import Foundation

/// Displayable fact card with priority system for UI presentation
struct Fact: Codable, Sendable, Hashable {
    /// Brief heading (e.g., "Sampled By", "Recording Location")
    let title: String

    /// Full fact text for display
    let detail: String

    /// Priority for ordering (1-5 scale, where 5 is highest priority)
    let priority: Int

    /// Category for grouping (e.g., "relationship", "credit", "recording", "context")
    let category: String

    /// Data source (e.g., "MusicBrainz", "Apple Music", "Listening History")
    let source: String

    init(title: String, detail: String, priority: Int, category: String, source: String) {
        self.title = title
        self.detail = detail
        self.priority = priority
        self.category = category
        self.source = source
    }
}
