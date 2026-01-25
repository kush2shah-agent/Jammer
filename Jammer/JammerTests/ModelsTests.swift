//
//  ModelsTests.swift
//  JammerTests
//
//  Created on 2026-01-25.
//

import Foundation
import Testing
@testable import Jammer

struct ModelsTests {
    // MARK: - Credit Tests

    @Test func creditCodableRoundtrip() throws {
        let credit = Credit(
            name: "Quincy Jones",
            role: "producer",
            instrument: nil
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(credit)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Credit.self, from: data)

        #expect(decoded.name == "Quincy Jones")
        #expect(decoded.role == "producer")
        #expect(decoded.instrument == nil)
    }

    @Test func creditWithInstrument() throws {
        let credit = Credit(
            name: "John Bonham",
            role: "musician",
            instrument: "drums"
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(credit)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Credit.self, from: data)

        #expect(decoded.name == "John Bonham")
        #expect(decoded.role == "musician")
        #expect(decoded.instrument == "drums")
    }

    @Test func creditFromJSON() throws {
        let json = """
        {
            "name": "George Martin",
            "role": "producer",
            "instrument": "piano"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let credit = try decoder.decode(Credit.self, from: json)

        #expect(credit.name == "George Martin")
        #expect(credit.role == "producer")
        #expect(credit.instrument == "piano")
    }

    // MARK: - RecordingInfo Tests

    @Test func recordingInfoCodableRoundtrip() throws {
        let info = RecordingInfo(
            studioName: "Abbey Road Studios",
            location: "London, UK",
            date: "June 1967"
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(info)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(RecordingInfo.self, from: data)

        #expect(decoded.studioName == "Abbey Road Studios")
        #expect(decoded.location == "London, UK")
        #expect(decoded.date == "June 1967")
    }

    @Test func recordingInfoWithNilValues() throws {
        let info = RecordingInfo(
            studioName: nil,
            location: "Los Angeles, CA",
            date: nil
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(info)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(RecordingInfo.self, from: data)

        #expect(decoded.studioName == nil)
        #expect(decoded.location == "Los Angeles, CA")
        #expect(decoded.date == nil)
    }

    @Test func recordingInfoFromJSON() throws {
        let json = """
        {
            "studioName": "Electric Lady Studios",
            "location": "New York, NY",
            "date": "March 1975"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let info = try decoder.decode(RecordingInfo.self, from: json)

        #expect(info.studioName == "Electric Lady Studios")
        #expect(info.location == "New York, NY")
        #expect(info.date == "March 1975")
    }

    // MARK: - Relationship Tests

    @Test func relationshipCodableRoundtrip() throws {
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

        #expect(decoded.type == "samples")
        #expect(decoded.targetTrack == "When the Levee Breaks")
        #expect(decoded.targetArtist == "Led Zeppelin")
        #expect(decoded.description == "Drum break sampled")
    }

    @Test func relationshipWithoutDescription() throws {
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

        #expect(decoded.type == "cover")
        #expect(decoded.targetTrack == "Respect")
        #expect(decoded.targetArtist == "Otis Redding")
        #expect(decoded.description == nil)
    }

    @Test func relationshipFromJSON() throws {
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

        #expect(relationship.type == "remix")
        #expect(relationship.targetTrack == "Blue Monday")
        #expect(relationship.targetArtist == "New Order")
        #expect(relationship.description == "Extended mix")
    }

    // MARK: - Fact Tests

    @Test func factCodableRoundtrip() throws {
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

        #expect(decoded.title == "Sampled By")
        #expect(decoded.detail == "This drum break was sampled in over 1000 hip-hop tracks")
        #expect(decoded.priority == 5)
        #expect(decoded.category == "relationship")
        #expect(decoded.source == "MusicBrainz")
    }

    @Test func factPriorityRange() throws {
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

        #expect(lowPriority.priority == 1)
        #expect(highPriority.priority == 5)
    }

    @Test func factFromJSON() throws {
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

        #expect(fact.title == "Recording Location")
        #expect(fact.detail == "Recorded at Abbey Road Studios, London in June 1967")
        #expect(fact.priority == 4)
        #expect(fact.category == "recording")
        #expect(fact.source == "MusicBrainz")
    }

    // MARK: - EnrichedTrack Tests

    @Test func enrichedTrackCodableRoundtrip() throws {
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

        #expect(decoded.title == "Billie Jean")
        #expect(decoded.artistName == "Michael Jackson")
        #expect(decoded.albumName == "Thriller")
        #expect(decoded.artworkURL == "https://example.com/artwork.jpg")
        #expect(decoded.duration == 294.0)
        #expect(decoded.isrc == "USSM18200123")
        #expect(decoded.musicKitTrackID == "12345")
    }

    @Test func enrichedTrackWithFullData() throws {
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

        #expect(decoded.title == "Billie Jean")
        #expect(decoded.credits.count == 3)
        #expect(decoded.credits[0].name == "Quincy Jones")
        #expect(decoded.recordingInfo?.studioName == "Westlake Recording Studios")
        #expect(decoded.relationships.count == 1)
        #expect(decoded.relationships[0].type == "sampled-by")
        #expect(decoded.facts.count == 2)
        #expect(decoded.facts[0].priority == 5)
    }

    @Test func enrichedTrackFromJSON() throws {
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

        #expect(track.title == "Smells Like Teen Spirit")
        #expect(track.artistName == "Nirvana")
        #expect(track.albumName == "Nevermind")
        #expect(track.credits.count == 2)
        #expect(track.recordingInfo?.studioName == "Sound City Studios")
        #expect(track.relationships.count == 1)
        #expect(track.facts.count == 1)
    }

    @Test func enrichedTrackWithNilOptionals() throws {
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

        #expect(decoded.artworkURL == nil)
        #expect(decoded.duration == nil)
        #expect(decoded.isrc == nil)
        #expect(decoded.credits.isEmpty)
        #expect(decoded.recordingInfo == nil)
        #expect(decoded.relationships.isEmpty)
        #expect(decoded.facts.isEmpty)
    }

    // MARK: - Sendable Conformance Tests

    @Test func creditIsSendable() {
        let credit = Credit(name: "Test", role: "test")
        Task {
            let _ = credit // Should compile without warnings if Sendable
        }
    }

    @Test func recordingInfoIsSendable() {
        let info = RecordingInfo(studioName: "Test Studio")
        Task {
            let _ = info // Should compile without warnings if Sendable
        }
    }

    @Test func relationshipIsSendable() {
        let rel = Relationship(type: "test", targetTrack: "Test", targetArtist: "Test")
        Task {
            let _ = rel // Should compile without warnings if Sendable
        }
    }

    @Test func factIsSendable() {
        let fact = Fact(title: "Test", detail: "Test", priority: 3, category: "test", source: "test")
        Task {
            let _ = fact // Should compile without warnings if Sendable
        }
    }

    @Test func enrichedTrackIsSendable() {
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
