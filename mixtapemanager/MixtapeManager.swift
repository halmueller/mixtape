//
//  MixtapeManager.swift
//  mixtapemanager
//
//  Created by Hal Mueller on 12/15/19.
//  Copyright © 2019 Hal Mueller. All rights reserved.
//

import Foundation

class MixtapeManager {

    func processMixtapeChanges(input: String, changeset: String, output: String) -> Bool {
        print(input, changeset, output)
        browseTape(filename: input)
        return true
    }

    func browseTape(filename: String) -> Bool {
        let fileURL: URL = URL(fileURLWithPath: filename)
        print(fileURL)
        let data = try! Data(contentsOf: fileURL)
        print(data)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
        print(#function, "found", json.count, "entries")
        print(json)
        print(json["users"])
        print(json["playlists"])
        print(json["songs"])
        return true
    }

    func mixtape(filename: String) -> Mixtape? {
        do {
            let fileURL: URL = URL(fileURLWithPath: filename)
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let mixtape = try decoder.decode(Mixtape.self, from: data)
            return mixtape
        }
        catch {
            print(error)
            return nil
        }
    }
}
