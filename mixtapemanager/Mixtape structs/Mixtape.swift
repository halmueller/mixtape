//
//  Mixtape.swift
//  mixtapemanager
//
//  Created by Hal Mueller on 12/16/19.
//  Copyright © 2019 Hal Mueller. All rights reserved.
//

import Foundation

struct Mixtape: Codable {
    let songs: [Song]
    let users: [User]
    let playlists: [Playlist]

    func add(songId: String, to playlistId: String) throws {

    }

    func add(playlist: Playlist) throws {

    }

    func removePlaylist(id: String) throws {

    }
}
