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

    func processMixtapeChanges(input: String, changes: String, output: String) throws -> Bool {
        print(input, changes, output)
        do {
            let mixtape = try self.mixtape(filename: input)
            let changeset = try self.changeset(filename: changes)
            for command in changeset.changes {
                try applyChange(command, to: mixtape)
            }
        }
        return true
    }

    func applyChange(_ command: ChangeCommand, to mixtape: Mixtape) throws {
        switch command.operation {
        case .addSong:
            print(command)
            guard let songId = command.songId else {throw(MixtapeManagerError.invalidChangeCommand)}
            guard let playlistId = command.playlistId else {throw(MixtapeManagerError.invalidChangeCommand)}
            try mixtape.add(songId: songId, to: playlistId)
        case .addPlaylist:
            print(command.operation)
            guard let playlist = command.playlist else {throw(MixtapeManagerError.invalidChangeCommand)}
            try mixtape.add(playlist: playlist)
        case .removePlaylist:
            print(command.operation)
            guard let playlistId = command.playlistId else {throw(MixtapeManagerError.invalidChangeCommand)}
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
            throw(error)
        }
    }

    func changeset(filename: String) throws -> Changeset {
        do {
            let fileURL: URL = URL(fileURLWithPath: filename)
            let data = try Data(contentsOf: fileURL)
            let result = try self.changeset(data: data)
            return result
        }
        catch {
            print(error)
            throw(error)
        }
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
            throw(error)
        }
    }

}
