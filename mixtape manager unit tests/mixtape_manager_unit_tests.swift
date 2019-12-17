//
//  mixtape_manager_unit_tests.swift
//  mixtape manager unit tests
//
//  Created by Hal Mueller on 12/16/19.
//  Copyright © 2019 Hal Mueller. All rights reserved.
//

import XCTest

// I'm force-unwrapping all over the place here. If it's going to fail I want to know about.

class mixtape_manager_unit_tests: XCTestCase {

    let manager = MixtapeManager()
    var inputTape: Mixtape? = nil

    override func setUp() {
        try! inputTape = manager.mixtape(data: Data(sampleString.utf8))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSimple() {
        let changeset = try! manager.changeset(data: Data(changesString.utf8))
        let playlist2 = inputTape!.playlists.first(where: {$0.id == "2"})
        XCTAssertNotNil(playlist2)
        XCTAssert(playlist2?.songIds.count == 3, "\(String(describing: playlist2?.songIds.count))")

        let playlist1 = inputTape!.playlists.first(where: {$0.id == "1"})
        XCTAssertNotNil(playlist1)

        for command in changeset.changes {
            XCTAssertNoThrow(try manager.applyChange(command, to: inputTape!))
        }

        XCTAssert(playlist2?.songIds.count == 4, "\(String(describing: playlist2?.songIds.count))")
        XCTAssert(playlist2?.songIds[0] == "6")
        XCTAssert(playlist2?.songIds[1] == "8")
        XCTAssert(playlist2?.songIds[2] == "11")
        XCTAssert(playlist2?.songIds[3] == "3")

        let playlist4 = inputTape!.playlists.first(where: {$0.id == "4"})
        XCTAssertNotNil(playlist4)
        XCTAssert(playlist4?.songIds.count == 4)
        XCTAssert(playlist4?.songIds[0] == "13")
        XCTAssert(playlist4?.songIds[1] == "12")
        XCTAssert(playlist4?.songIds[2] == "16")
        XCTAssert(playlist4?.songIds[3] == "2")

        let playlist1after = inputTape!.playlists.first(where: {$0.id == "1"})
        XCTAssertNil(playlist1after)
    }

    func testDoubleRemove() {
        let command = ChangeCommand.init(operation: .removePlaylist, playlistId: "1", songId: nil, playlist: nil)
        XCTAssertNoThrow(try manager.applyChange(command, to: inputTape!))
        // removing it a second time should fail
        XCTAssertThrowsError(try manager.applyChange(command, to: inputTape!))
    }

    func testDoubleAdd() {
        let playlistString = "{ \"id\" : \"4\", \"user_id\" : \"7\", \"song_ids\" : [  \"13\",  \"12\",  \"16\", \"2\" ]  }"
        let playlistData = Data(playlistString.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let playlist = try! decoder.decode(Playlist.self, from: playlistData)
        let command = ChangeCommand.init(operation: .addPlaylist, playlistId: nil, songId: nil, playlist: playlist)
        XCTAssertNoThrow(try manager.applyChange(command, to: inputTape!))
        // adding duplicate playlist ID should throw error
        XCTAssertThrowsError(try manager.applyChange(command, to: inputTape!))
    }

    func testDegeneratePlaylist() {
        // a playlist can only contain existing songs
        let playlistString = "{ \"id\" : \"4\", \"user_id\" : \"7\", \"song_ids\" : [ \"314159\", \"271828\" ]  }"
        let playlistData = Data(playlistString.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let playlist = try! decoder.decode(Playlist.self, from: playlistData)
        let command = ChangeCommand.init(operation: .addPlaylist, playlistId: nil, songId: nil, playlist: playlist)
        XCTAssertThrowsError(try manager.applyChange(command, to: inputTape!))
    }

    func testEmptyPlaylist() {
        // a playlist with no songs is illegal
        let playlistString = "{ \"id\" : \"4\", \"user_id\" : \"7\", \"song_ids\" : [  ]  }"
        let playlistData = Data(playlistString.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let playlist = try! decoder.decode(Playlist.self, from: playlistData)
        let command = ChangeCommand.init(operation: .addPlaylist, playlistId: nil, songId: nil, playlist: playlist)
        XCTAssertThrowsError(try manager.applyChange(command, to: inputTape!))
    }

    func testIncompleteCommand() {
        // .addSong command without a playlistId
        let addSong = ChangeCommand.init(operation: .addSong, playlistId: nil, songId: "3", playlist: nil)
        XCTAssertThrowsError(try manager.applyChange(addSong, to: inputTape!))

        // extra field, missing playlist
        let addPlaylist = ChangeCommand.init(operation: .addPlaylist, playlistId: nil, songId: "3", playlist: nil)
        XCTAssertThrowsError(try manager.applyChange(addPlaylist, to: inputTape!))

        // missing playlistID
        let removePlaylist = ChangeCommand.init(operation: .removePlaylist, playlistId: nil, songId: nil, playlist: nil)
        XCTAssertThrowsError(try manager.applyChange(removePlaylist, to: inputTape!))
    }

    /// The JSON sample from Thomas's gist.
    let sampleString = "{ \"users\" : [ { \"id\" : \"1\", \"name\" : \"Albin Jaye\" }, { \"id\" : \"2\", \"name\" : \"Dipika Crescentia\" }, { \"id\" : \"3\", \"name\" : \"Ankit Sacnite\" }, { \"id\" : \"4\", \"name\" : \"Galenos Neville\" }, { \"id\" : \"5\", \"name\" : \"Loviise Nagib\" }, { \"id\" : \"6\", \"name\" : \"Ryo Daiki\" }, { \"id\" : \"7\", \"name\" : \"Seyyit Nedim\" } ], \"playlists\" : [ { \"id\" : \"1\", \"user_id\" : \"2\", \"song_ids\" : [ \"8\", \"32\" ] }, { \"id\" : \"2\", \"user_id\" : \"3\", \"song_ids\" : [ \"6\", \"8\", \"11\" ] }, { \"id\" : \"3\", \"user_id\" : \"7\", \"song_ids\" : [ \"7\", \"12\", \"13\", \"16\", \"2\" ] } ], \"songs\": [ { \"id\" : \"1\", \"artist\": \"Camila Cabello\", \"title\": \"Never Be the Same\" }, { \"id\" : \"2\", \"artist\": \"Zedd\", \"title\": \"The Middle\" }, { \"id\" : \"3\", \"artist\": \"The Weeknd\", \"title\": \"Pray For Me\" }, { \"id\" : \"4\", \"artist\": \"Drake\", \"title\": \"God's Plan\" }, { \"id\" : \"5\", \"artist\": \"Bebe Rexha\", \"title\": \"Meant to Be\" }, { \"id\" : \"6\", \"artist\": \"Imagine Dragons\", \"title\": \"Whatever It Takes\" }, { \"id\" : \"7\", \"artist\": \"Maroon 5\", \"title\": \"Wait\" }, { \"id\" : \"8\", \"artist\": \"Bazzi\", \"title\": \"Mine\" }, { \"id\" : \"9\", \"artist\": \"Marshmello\", \"title\": \"FRIENDS\" }, { \"id\" : \"10\", \"artist\": \"Dua Lipa\", \"title\": \"New Rules\" }, { \"id\" : \"11\", \"artist\": \"Shawn Mendes\", \"title\": \"In My Blood\" }, { \"id\" : \"12\", \"artist\": \"Post Malone\", \"title\": \"Psycho\" }, { \"id\" : \"13\", \"artist\": \"Ariana Grande\", \"title\": \"No Tears Left To Cry\" }, { \"id\" : \"14\", \"artist\": \"Bruno Mars\", \"title\": \"Finesse\" }, { \"id\" : \"15\", \"artist\": \"Kendrick Lamar\", \"title\": \"All The Stars\" }, { \"id\" : \"16\", \"artist\": \"G-Eazy\", \"title\": \"Him & I\" }, { \"id\" : \"17\", \"artist\": \"Lauv\", \"title\": \"I Like Me Better\" }, { \"id\" : \"18\", \"artist\": \"NF\", \"title\": \"Let You Down\" }, { \"id\" : \"19\", \"artist\": \"Dua Lipa\", \"title\": \"IDGAF\" }, { \"id\" : \"20\", \"artist\": \"Taylor Swift\", \"title\": \"Delicate\" }, { \"id\" : \"21\", \"artist\": \"Calvin Harris\", \"title\": \"One Kiss\" }, { \"id\" : \"22\", \"artist\": \"Ed Sheeran\", \"title\": \"Perfect\" }, { \"id\" : \"23\", \"artist\": \"Meghan Trainor\", \"title\": \"No Excuses\" }, { \"id\" : \"24\", \"artist\": \"Niall Horan\", \"title\": \"On The Loose\" }, { \"id\" : \"25\", \"artist\": \"Halsey\", \"title\": \"Alone\" }, { \"id\" : \"26\", \"artist\": \"Charlie Puth\", \"title\": \"Done For Me\" }, { \"id\" : \"27\", \"artist\": \"Foster The People\", \"title\": \"Sit Next to Me\" }, { \"id\" : \"28\", \"artist\": \"Max\", \"title\": \"Lights Down Low\" }, { \"id\" : \"29\", \"artist\": \"Alice Merton\", \"title\": \"No Roots\" }, { \"id\" : \"30\", \"artist\": \"5 Seconds Of Summer\", \"title\": \"Want You Back\" }, { \"id\" : \"31\", \"artist\": \"Camila Cabello\", \"title\": \"Havana\" }, { \"id\" : \"32\", \"artist\": \"Logic\", \"title\": \"Everyday\" }, { \"id\" : \"33\", \"artist\": \"Drake\", \"title\": \"Nice For What\" }, { \"id\" : \"34\", \"artist\": \"Halsey\", \"title\": \"Bad At Love\" }, { \"id\" : \"35\", \"artist\": \"ZAYN\", \"title\": \"Let Me\" }, { \"id\" : \"36\", \"artist\": \"Khalid\", \"title\": \"Love Lies\" }, { \"id\" : \"37\", \"artist\": \"Post Malone\", \"title\": \"rockstar\" }, { \"id\" : \"38\", \"artist\": \"Rudimental\", \"title\": \"These Days\" }, { \"id\" : \"39\", \"artist\": \"Liam Payne\", \"title\": \"Familiar\" }, { \"id\" : \"40\", \"artist\": \"Imagine Dragons\", \"title\": \"Thunder\" } ]}"

    /// The changes1.json file from the `samples` folder.
    let changesString = "{  \"changes\" : [ {  \"operation\" : \"addSong\",  \"playlist_id\" : \"2\",  \"song_id\" : \"3\" },  {  \"operation\" : \"addPlaylist\",  \"playlist\" : { \"id\" : \"4\", \"user_id\" : \"7\", \"song_ids\" : [  \"13\",  \"12\",  \"16\",  \"2\" ]  } },  {  \"operation\" : \"removePlaylist\",  \"playlist_id\" : \"1\" }  ] }"
}
