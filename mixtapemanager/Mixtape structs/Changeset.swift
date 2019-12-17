//
//  Changeset.swift
//  mixtapemanager
//
//  Created by Hal Mueller on 12/16/19.
//  Copyright © 2019 Hal Mueller. All rights reserved.
//

import Foundation

/// A sample Changeset is in `samples` folder. Unneeded keys may be omitted. For example,
/// there's no need to provide a user ID in a change command that removes a playlist.
struct Changeset: Codable {
    let changes: [ChangeCommand]
}
