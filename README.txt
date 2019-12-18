Tools used: Xcode 11.3, and macOS Catalina 10.15.2. Deployment target is 10.15. Swift version 5.1.

Usage: mixtapemanager <input-file> <changes-file> <output-file>

Input and changes files must exist. Output-file is overwritten if it exists.

The Xcode scheme has command line arguments included. After you change them to match your file location, you can just use command-R to run a sample. Command-R without updating the schema will almost certainly fail. Or you can drag the “mixtapemanager” from the Products folder in Xcode to a Terminal window, and add names of your files directly to the command line.

Invoke unit tests with command-U. All data needed for the unit tests is within the unit test bundle; there are no filesystem dependencies.

The changes file is in JSON format. It is an array of operations to perform, with operands supplied in each array element. See samples/changes1.json for an example. Operands not needed by a particular operation may be omitted if you like. For example, the “removePlaylist” operation needs only the playlist ID.

The actual work is done by the MixtapeManager class. The supplied main.swift creates a MixtapeManager instance and invokes the change processing using the supplied filenames. All error handling is performed within the MixtapeManager or its components.

Any errors in the JSON itself, or logic errors in the changeset (such as omitting the song ID from “addSong”, or supplying an empty song IDs array to “addPlaylist”) will throw an error, and cause the command line app to exit with an exit code of 1 without attempting to write the output file. Successful operation (including creating the output file) exits with 0. Filesystem access/rights/existence errors will throw an error. See the enum MixtapeManagerError for Mixtape-specific errors. Filesystem and JSON errors use Foundation’s error definitions.

Possible places for speedups with very large files:
1. Memory-map the JSON files.
2. Parse Mixtape and Changeset on different queues.
3. Look into SIMD JSON parsers: 
    https://github.com/lemire/simdjson looks pretty cool, and has a Swift interface at https://github.com/michaeleisel/zippyjson. 
    Mison: a fast JSON parser for data analytics. https://www.researchgate.net/publication/319597814_Mison_a_fast_JSON_parser_for_data_analytics.
4. Split Changeset operations per user. Each user's operations go into a separate serial queue.
5. Consider coalescing operations in the Changeset, if there tend to be many changes for a particular user or playlist that cancel each other out.
