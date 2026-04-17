//
//  ModelsTests.swift
//  JammerTests
//
//  Created on 2026-01-25.
//

import Foundation
import XCTest
@testable import Jammer

final class ModelsTests: XCTestCase {
    // MARK: - Credit Tests

    func testCreditCodableRoundtrip() throws {
        let credit = Credit(
            name: "Quincy Jones",
            role: "producer",
            instrument: nil
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(credit)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Credit.self, from: data)

        XCTAssertEqual(decoded.name, "Quincy Jones")
        XCTAssertEqual(decoded.role, "producer")
        XCTAssertNil(decoded.instrument)
    }

    func testCreditWithInstrument() throws {
        let credit = Credit(
            name: "John Bonham",
            role: "musician",
            instrument: "drums"
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(credit)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Credit.self, from: data)

        XCTAssertEqual(decoded.name, "John Bonham")
        XCTAssertEqual(decoded.role, "musician")
        XCTAssertEqual(decoded.instrument, "drums")
    }

    func testCreditFromJSON() throws {
        let json = """
        {
            "name": "George Martin",
            "role": "producer",
            "instrument": "piano"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let credit = try decoder.decode(Credit.self, from: json)

        XCTAssertEqual(credit.name, "George Martin")
        XCTAssertEqual(credit.role, "producer")
        XCTAssertEqual(credit.instrument, "piano")
    }

    // MARK: - RecordingInfo Tests

    func testRecordingInfoCodableRoundtrip() throws {
        let info = RecordingInfo(
            studioName: "Abbey Road Studios",
            location: "London, UK",
            date: "June 1967"
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(info)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(RecordingInfo.self, from: data)

        XCTAssertEqual(decoded.studioName, "Abbey Road Studios")
        XCTAssertEqual(decoded.location, "London, UK")
        XCTAssertEqual(decoded.date, "June 1967")
    }

    func testRecordingInfoWithNilValues() throws {
        let info = RecordingInfo(
            studioName: nil,
            location: "Los Angeles, CA",
            date: nil
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(info)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(RecordingInfo.self, from: data)

        XCTAssertNil(decoded.studioName)
        XCTAssertEqual(decoded.location, "Los Angeles, CA")
        XCTAssertNil(decoded.date)
    }

    func testRecordingInfoFromJSON() throws {
        let json = """
        {
            "studioName": "Electric Lady Studios",
            "location": "New York, NY",
            "date": "March 1975"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let info = try decoder.decode(RecordingInfo.self, from: json)

        XCTAssertEqual(info.studioName, "Electric Lady Studios")
        XCTAssertEqual(info.location, "New York, NY")
        XCTAssertEqual(info.date, "March 1975")
    }

    // MARK: - Relationship Tests

    func testRelationshipCodableRoundtrip() throws {
        let relationship = Relationship(
            type: "samples",
            targetTrack: "When the Levee Breaks",
            targetArtist: "Led Zeppelin",
            description: "Drum break sampled"
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(relationship)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Relationship.self, from: data)

        XCTAssertEqual(decoded.type, "samples")
        XCTAssertEqual(decoded.targetTrack, "When the Levee Breaks")
        XCTAssertEqual(decoded.targetArtist, "Led Zeppelin")
        XCTAssertEqual(decoded.description, "Drum break sampled")
    }

    func testRelationshipWithoutDescription() throws {
        let relationship = Relationship(
            type: "cover",
            targetTrack: "Respect",
            targetArtist: "Otis Redding",
            description: nil
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(relationship)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Relationship.self, from: data)

        XCTAssertEqual(decoded.type, "cover")
        XCTAssertEqual(decoded.targetTrack, "Respect")
        XCTAssertEqual(decoded.targetArtist, "Otis Redding")
        XCTAssertNil(decoded.description)
    }

    func testRelationshipFromJSON() throws {
        let json = """
        {
            "type": "remix",
            "targetTrack": "Blue Monday",
            "targetArtist": "New Order",
            "description": "Extended mix"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let relationship = try decoder.decode(Relationship.self, from: json)

        XCTAssertEqual(relationship.type, "remix")
        XCTAssertEqual(relationship.targetTrack, "Blue Monday")
        XCTAssertEqual(relationship.targetArtist, "New Order")
        XCTAssertEqual(relationship.description, "Extended mix")
    }

    // MARK: - Fact Tests

    func testFactCodableRoundtrip() throws {
        let fact = Fact(
            title: "Sampled By",
            detail: "This drum break was sampled in over 1000 hip-hop tracks",
            priority: 5,
            category: "relationship",
            source: "MusicBrainz"
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(fact)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Fact.self, from: data)

        XCTAssertEqual(decoded.title, "Sampled By")
        XCTAssertEqual(decoded.detail, "This drum break was sampled in over 1000 hip-hop tracks")
        XCTAssertEqual(decoded.priority, 5)
        XCTAssertEqual(decoded.category, "relationship")
        XCTAssertEqual(decoded.source, "MusicBrainz")
    }

    func testFactPriorityRange() throws {
        let lowPriority = Fact(
            title: "Minor Detail",
            detail: "Some additional context",
            priority: 1,
            category: "context",
            source: "MusicBrainz"
        )

        let highPriority = Fact(
            title: "Major Discovery",
            detail: "This is important information",
            priority: 5,
            category: "recording",
            source: "Apple Music"
        )

        XCTAssertEqual(lowPriority.priority, 1)
        XCTAssertEqual(highPriority.priority, 5)
    }

    func testFactFromJSON() throws {
        let json = """
        {
            "title": "Recording Location",
            "detail": "Recorded at Abbey Road Studios, London in June 1967",
            "priority": 4,
            "category": "recording",
            "source": "MusicBrainz"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let fact = try decoder.decode(Fact.self, from: json)

        XCTAssertEqual(fact.title, "Recording Location")
        XCTAssertEqual(fact.detail, "Recorded at Abbey Road Studios, London in June 1967")
        XCTAssertEqual(fact.priority, 4)
        XCTAssertEqual(fact.category, "recording")
        XCTAssertEqual(fact.source, "MusicBrainz")
    }

    // MARK: - EnrichedTrack Tests

    func testEnrichedTrackCodableRoundtrip() throws {
        let track = EnrichedTrack(
            title: "Billie Jean",
            artistName: "Michael Jackson",
            albumName: "Thriller",
            artworkURL: "https://example.com/artwork.jpg",
            duration: 294.0,
            isrc: "USSM18200123",
            musicKitTrackID: "12345",
            credits: [],
            recordingInfo: nil,
            relationships: [],
            facts: []
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(track)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(EnrichedTrack.self, from: data)

        XCTAssertEqual(decoded.title, "Billie Jean")
        XCTAssertEqual(decoded.artistName, "Michael Jackson")
        XCTAssertEqual(decoded.albumName, "Thriller")
        XCTAssertEqual(decoded.artworkURL, "https://example.com/artwork.jpg")
        XCTAssertEqual(decoded.duration, 294.0)
        XCTAssertEqual(decoded.isrc, "USSM18200123")
        XCTAssertEqual(decoded.musicKitTrackID, "12345")
    }

    func testEnrichedTrackWithFullData() throws {
        let credits = [
            Credit(name: "Quincy Jones", role: "producer", instrument: nil),
            Credit(name: "Bruce Swedien", role: "engineer", instrument: nil),
            Credit(name: "Michael Jackson", role: "musician", instrument: "vocals")
        ]

        let recordingInfo = RecordingInfo(
            studioName: "Westlake Recording Studios",
            location: "Los Angeles, CA",
            date: "1982"
        )

        let relationships = [
            Relationship(
                type: "sampled-by",
                targetTrack: "Ignition (Remix)",
                targetArtist: "R. Kelly",
                description: "Bass line sampled"
            )
        ]

        let facts = [
            Fact(
                title: "Production",
                detail: "Produced by Quincy Jones at Westlake Recording Studios",
                priority: 5,
                category: "credit",
                source: "MusicBrainz"
            ),
            Fact(
                title: "Legacy",
                detail: "This track has been sampled in numerous hip-hop songs",
                priority: 4,
                category: "relationship",
                source: "MusicBrainz"
            )
        ]

        let track = EnrichedTrack(
            title: "Billie Jean",
            artistName: "Michael Jackson",
            albumName: "Thriller",
            artworkURL: "https://example.com/artwork.jpg",
            duration: 294.0,
            isrc: "USSM18200123",
            musicKitTrackID: "12345",
            credits: credits,
            recordingInfo: recordingInfo,
            relationships: relationships,
            facts: facts
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(track)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(EnrichedTrack.self, from: data)

        XCTAssertEqual(decoded.title, "Billie Jean")
        XCTAssertEqual(decoded.credits.count, 3)
        XCTAssertEqual(decoded.credits[0].name, "Quincy Jones")
        XCTAssertEqual(decoded.recordingInfo?.studioName, "Westlake Recording Studios")
        XCTAssertEqual(decoded.relationships.count, 1)
        XCTAssertEqual(decoded.relationships[0].type, "sampled-by")
        XCTAssertEqual(decoded.facts.count, 2)
        XCTAssertEqual(decoded.facts[0].priority, 5)
    }

    func testEnrichedTrackFromJSON() throws {
        let json = """
        {
            "title": "Smells Like Teen Spirit",
            "artistName": "Nirvana",
            "albumName": "Nevermind",
            "artworkURL": "https://example.com/nevermind.jpg",
            "duration": 301.0,
            "isrc": "USDGG9104702",
            "musicKitTrackID": "67890",
            "credits": [
                {
                    "name": "Butch Vig",
                    "role": "producer"
                },
                {
                    "name": "Kurt Cobain",
                    "role": "musician",
                    "instrument": "guitar"
                }
            ],
            "recordingInfo": {
                "studioName": "Sound City Studios",
                "location": "Van Nuys, CA",
                "date": "May 1991"
            },
            "relationships": [
                {
                    "type": "cover",
                    "targetTrack": "More Than a Feeling",
                    "targetArtist": "Boston",
                    "description": "Riff inspired by"
                }
            ],
            "facts": [
                {
                    "title": "Recording",
                    "detail": "Recorded at Sound City Studios with Butch Vig",
                    "priority": 4,
                    "category": "recording",
                    "source": "MusicBrainz"
                }
            ]
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let track = try decoder.decode(EnrichedTrack.self, from: json)

        XCTAssertEqual(track.title, "Smells Like Teen Spirit")
        XCTAssertEqual(track.artistName, "Nirvana")
        XCTAssertEqual(track.albumName, "Nevermind")
        XCTAssertEqual(track.credits.count, 2)
        XCTAssertEqual(track.recordingInfo?.studioName, "Sound City Studios")
        XCTAssertEqual(track.relationships.count, 1)
        XCTAssertEqual(track.facts.count, 1)
    }

    func testEnrichedTrackWithNilOptionals() throws {
        let track = EnrichedTrack(
            title: "Test Track",
            artistName: "Test Artist",
            albumName: "Test Album",
            artworkURL: nil,
            duration: nil,
            isrc: nil,
            musicKitTrackID: "test123"
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(track)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(EnrichedTrack.self, from: data)

        XCTAssertNil(decoded.artworkURL)
        XCTAssertNil(decoded.duration)
        XCTAssertNil(decoded.isrc)
        XCTAssertTrue(decoded.credits.isEmpty)
        XCTAssertNil(decoded.recordingInfo)
        XCTAssertTrue(decoded.relationships.isEmpty)
        XCTAssertTrue(decoded.facts.isEmpty)
    }

    // MARK: - Sendable Conformance Tests

    func testCreditIsSendable() {
        let credit = Credit(name: "Test", role: "test")
        Task {
            let _ = credit // Should compile without warnings if Sendable
        }
    }

    func testRecordingInfoIsSendable() {
        let info = RecordingInfo(studioName: "Test Studio")
        Task {
            let _ = info // Should compile without warnings if Sendable
        }
    }

    func testRelationshipIsSendable() {
        let rel = Relationship(type: "test", targetTrack: "Test", targetArtist: "Test")
        Task {
            let _ = rel // Should compile without warnings if Sendable
        }
    }

    func testFactIsSendable() {
        let fact = Fact(title: "Test", detail: "Test", priority: 3, category: "test", source: "test")
        Task {
            let _ = fact // Should compile without warnings if Sendable
        }
    }

    func testEnrichedTrackIsSendable() {
        let track = EnrichedTrack(
            title: "Test",
            artistName: "Test",
            albumName: "Test",
            musicKitTrackID: "test"
        )
        Task {
            let _ = track // Should compile without warnings if Sendable
        }
    }
}
