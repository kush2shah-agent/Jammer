//
//  RecordingInfo.swift
//  Jammer
//
//  Created on 2026-01-25.
//

import Foundation

/// Recording details including studio, location, and date information
struct RecordingInfo: Codable, Sendable, Hashable {
    /// Recording studio name
    let studioName: String?

    /// Combined city/country location (e.g., "Abbey Road Studios, London")
    let location: String?

    /// Human-readable date (e.g., "May 1967", not strict ISO format)
    let date: String?

    init(studioName: String? = nil, location: String? = nil, date: String? = nil) {
        self.studioName = studioName
        self.location = location
        self.date = date
    }
}
