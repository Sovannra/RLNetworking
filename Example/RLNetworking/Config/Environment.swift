//
//  Environment.swift
//  ios-app-milio
//
//  Created by IG_Se7enzZ on 7/8/20.
//  Copyright © 2020 Core-MVVM. All rights reserved.
//

import Foundation

final class Environment {
    
    static let BUILD_TYPE_DEBUG   = "DEBUG"
    static let BUILD_TYPE_RELEASE = "RELEASE"
    
    static let BASE_URL        = infoForKey("Base url")!
    static let BASE_SOCKET_URL = infoForKey("Base socket url")!
    static let BASE_KEY_URL    = infoForKey("Base key url")!
    // Filter object in info.plist
    static func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
    
}
