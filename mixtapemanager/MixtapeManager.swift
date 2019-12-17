//
//  MixtapeManager.swift
//  mixtapemanager
//
//  Created by Hal Mueller on 12/15/19.
//  Copyright © 2019 Hal Mueller. All rights reserved.
//

import Foundation

enum MixtapeManagerError: Error {
    case invalidMixtape
    case invalidChangeset
    case invalidChangeCommand
    case songNotFound
    case playlistNotFound
    case playlistExists
    case userNotFound
}

class MixtapeManager {

    /// The key function for the assignment. Throws various `MixtapeError`s for requests that are impossible or invalid. Allow the system's errors
    /// thrown for invalid JSON or inaccessible files to be thrown without catching them.
    func processMixtapeChanges(input: String, changes: String, output: String) throws -> Bool {
        print(input)
        print(changes)
        print(output)
        let mixtape = try self.mixtape(filename: input)
        let changeset = try self.changeset(filename: changes)
        for command in changeset.changes {
            try applyChange(command, to: mixtape)
        }
        return true
    }

    /// Execute a command from a changese to modify our `Mixtape`. Validate that the command contains all necessary operands, e.g. that `removePlaylist`
    /// actually contains a `playlistId`, but let the `Mixtape` object decide whether the data makes sense, e.g. that the playlist we're deleting exists.
    /// Throw errors on invalid operands.
    func applyChange(_ command: ChangeCommand, to mixtape: Mixtape) throws {
        switch command.operation {
        case .addSong:
            guard let songId = command.songId else { throw(MixtapeManagerError.invalidChangeCommand) }
            guard let playlistId = command.playlistId else { throw(MixtapeManagerError.invalidChangeCommand) }
            try mixtape.add(songId: songId, to: playlistId)
        case .addPlaylist:
            guard let playlist = command.playlist else { throw(MixtapeManagerError.invalidChangeCommand) }
            try mixtape.add(playlist: playlist)
        case .removePlaylist:
            guard let playlistId = command.playlistId else { throw(MixtapeManagerError.invalidChangeCommand) }
            try mixtape.removePlaylist(id: playlistId)
        }
    }

    func mixtape(filename: String) throws -> Mixtape {
        let fileURL: URL = URL(fileURLWithPath: filename)
        let data = try Data(contentsOf: fileURL)
        let mixtape = try self.mixtape(data: data)
        return mixtape
    }

    func mixtape(data: Data) throws -> Mixtape  {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let mixtape = try decoder.decode(Mixtape.self, from: data)
            return mixtape
        }
        catch {
            print(error)
            throw(MixtapeManagerError.invalidMixtape)
        }
    }

    func changeset(filename: String) throws -> Changeset {
        let fileURL: URL = URL(fileURLWithPath: filename)
        let data = try Data(contentsOf: fileURL)
        let result = try self.changeset(data: data)
        return result
    }

    func changeset(data: Data) throws -> Changeset  {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(Changeset.self, from: data)
            return result
        }
        catch {
            print(error)
            throw(MixtapeManagerError.invalidChangeset)
        }

    }
}
