//
//  JammerTests.swift
//  JammerTests
//
//  Created by Kush Shah on 1/25/26.
//

import Testing
import CoreGraphics
@testable import Jammer

struct JammerTests {
    @Test(arguments: [
        CGSize(width: 180, height: 600),
        CGSize(width: 0, height: 600),
        CGSize(width: 32, height: 600),
        CGSize(width: 320, height: 200),
        CGSize(width: 1_200, height: 1_600)
    ])
    func artworkFitsItsContainer(size: CGSize) {
        let artwork = NowPlayingView.artworkSize(in: size)
        #expect(artwork >= 0)
        #expect(artwork <= max(0, size.width - 48))
        #expect(artwork <= size.height * 0.5)
        #expect(artwork <= 400)
    }

    @Test func artworkUsesAvailableSpace() {
        #expect(NowPlayingView.artworkSize(in: CGSize(width: 180, height: 600)) == 132)
        #expect(NowPlayingView.artworkSize(in: CGSize(width: 1_200, height: 1_600)) == 400)
    }

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}
