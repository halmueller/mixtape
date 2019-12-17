//
//  Mixtape.swift
//  mixtapemanager
//
//  Created by Hal Mueller on 12/16/19.
//  Copyright © 2019 Hal Mueller. All rights reserved.
//

import Foundation

class Mixtape: Codable {
    var songs: [Song]
    var users: [User]
    var playlists: [Playlist]

    /// Append existing `songId` to existing `playlistId`. Throws an error if either song or playlist does not exist.
    func add(songId: String, to playlistId: String) throws {
        guard songs.first(where: {$0.id == songId}) != nil else { throw(MixtapeManagerError.songNotFound) }
        guard var playlist = playlists.first(where: {$0.id == playlistId}) else { throw(MixtapeManagerError.playlistNotFound) }
        playlist.songIds.append(songId)
    }

    /// Add `playlist` to the playlists. Throws an error if a playlist already exist with `playlist.id` or if `playlist.userID` does not exist.
    func add(playlist: Playlist) throws {
        guard users.first(where: {$0.id == playlist.userId}) != nil else { throw(MixtapeManagerError.userNotFound) }
        guard playlists.first(where: {$0.id == playlist.id}) == nil else { throw(MixtapeManagerError.playlistExists) }
        playlists.append(playlist)
    }

    /// Remove existing playlist with `id` of `playlistId`. Throws an error if playlist does not exist.
    func removePlaylist(id: String) throws {
        guard let playlistIndex = playlists.firstIndex(where: {$0.id == id}) else { throw(MixtapeManagerError.playlistNotFound) }
        playlists.remove(at: playlistIndex)
    }
}
