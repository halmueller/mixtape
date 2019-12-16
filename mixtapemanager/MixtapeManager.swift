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
        let mixtape = self.mixtape(filename: input)
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
