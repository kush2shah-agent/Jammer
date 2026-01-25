//
//  Credit.swift
//  Jammer
//
//  Created on 2026-01-25.
//

import Foundation

/// Represents personnel credits for a track (producer, engineer, musicians, etc.)
struct Credit: Codable, Sendable, Hashable {
    /// Person or artist name
    let name: String

    /// Role or credit type (e.g., "producer", "engineer", "drums", "vocals")
    let role: String

    /// Specific instrument (optional, primarily for musicians)
    let instrument: String?

    init(name: String, role: String, instrument: String? = nil) {
        self.name = name
        self.role = role
        self.instrument = instrument
    }
}
