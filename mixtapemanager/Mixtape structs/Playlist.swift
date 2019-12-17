//
//  Playlist.swift
//  mixtapemanager
//
//  Created by Hal Mueller on 12/16/19.
//  Copyright © 2019 Hal Mueller. All rights reserved.
//

import Foundation

// Has to be a class because the `songIds` property is manipulated.
class Playlist: Codable {
    let id: String
    let userId: String
    var songIds: [String]
}
