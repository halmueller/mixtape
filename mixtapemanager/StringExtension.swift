//
//  StringExtension.swift
//  mixtapemanager
//
//  Created by Hal Mueller on 12/16/19.
//  Copyright © 2019 Hal Mueller. All rights reserved.
//

import Foundation

extension String {
    /// No, `expandingTildeInPath` didn't get ported to `String` from `NSString`. No, I don't know why.
    ///
    /// NSURL/NSString used to convert tilde in pathnames to the full path to the user's home directory. URL/String do not.
    func expandingTildeInPath() -> String {
        let nsstring = NSString.init(string: self).expandingTildeInPath
        return String.init(nsstring)
    }
}
