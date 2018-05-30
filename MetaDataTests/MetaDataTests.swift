//
//  MetaDataTests.swift
//  MetaDataTests
//
//  Created by Melanija Grunte on 06/11/2017.
//  Copyright © 2017 Melanija Grunte. All rights reserved.
//

import XCTest
@testable import MetaData

class MetaDataTests: XCTestCase {

    //MARK: Song Class Tests

    func testSongInitializationSucceeds() {

        let emptyStringSong = Song.init(FileName: "", Title: nil, Artist: nil, Album: nil, Track: nil, Year: nil, Genre: nil, Composer: nil, Comment: nil, AlbumArtImage: nil, AlbumArtist: nil)
        XCTAssertNil(emptyStringSong)

}
}
