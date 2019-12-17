//
//  ChangeCommand.swift
//  mixtapemanager
//
//  Created by Hal Mueller on 12/16/19.
//  Copyright © 2019 Hal Mueller. All rights reserved.
//

import Foundation

enum OperationType: String, Codable {
    case addSong, addPlaylist, removePlaylist
}

/// A change operation to be performed on a `Mixtape`. Properites that aren't applicable to a particular `OperationType` may be left `nil`.
struct ChangeCommand: Codable {
    let operation: OperationType
    let playlistId: String?
    let songId: String?
    let playlist: Playlist?
}
