//
//  Playlist.swift
//  mixtapemanager
//
//  Created by Hal Mueller on 12/16/19.
//  Copyright © 2019 Hal Mueller. All rights reserved.
//

import Foundation

struct Playlist: Codable {
    let id: String
    let userId: String
    let songIds: [String]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case songIds = "song_ids"
    }
}
