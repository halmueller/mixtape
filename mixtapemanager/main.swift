//
//  main.swift
//  mixtapemanager
//
//  Created by Hal Mueller on 12/15/19.
//  Copyright © 2019 Hal Mueller. All rights reserved.
//

import Foundation

// error check here: did we get right number of arguments?
guard CommandLine.arguments.count == 4 else {
    print("usage: mixtapemanager <input-file> <changes-file> <output-file>")
    exit(EXIT_FAILURE)
}

let inputTapeName = CommandLine.arguments[1].expandingTildeInPath()
let changesetName = CommandLine.arguments[2].expandingTildeInPath()
let outputTapeName = CommandLine.arguments[3].expandingTildeInPath()
let manager = MixtapeManager()

//if let mixtape = manager.mixtape(filename: inputTapeName) {
//    let encoder = JSONEncoder()
//    encoder.keyEncodingStrategy = .convertToSnakeCase
//    let roundtrip = try encoder.encode(mixtape)
//    print(String(data: roundtrip, encoding: .utf8) ?? "roundtrip failed")
//}

do {
    try manager.processMixtapeChanges(input: inputTapeName,
                                      changes: changesetName,
                                      output: outputTapeName)
    exit(EXIT_SUCCESS)
}
catch {
    print(error)
    exit(EXIT_FAILURE)
}

