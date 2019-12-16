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

let processingSucceeded = manager.processMixtapeChanges(input: inputTapeName,
                                                        changeset: changesetName,
                                                        output: outputTapeName)

let mixtape = manager.mixtape(filename: inputTapeName)

if processingSucceeded {
    exit(EXIT_SUCCESS)
} else {
    exit(EXIT_FAILURE)
}
