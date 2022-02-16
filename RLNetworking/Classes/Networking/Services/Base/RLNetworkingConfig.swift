//
//  RLNetworkingConfig.swift
//  RLNetworking
//
//  Created by Sovannra on 16/2/22.
//

import Foundation

public class RLNetworkConfig: NSObject {
    
    /**
     To store BaseUrl value from Enviroment
     This value use in TargetType for base url
     */
    @objc public lazy var baseUrl: String = ""
    
    /**
     To store user access token
     This value use in TargetType for authorization
     */
    @objc public lazy var accessToken: String = ""
    
}

public struct RLNetworkConstant {
    
    static var baseUrl: String = ""
    static var token: String   = ""
    
    public static func config(_ config: RLNetworkConfig) {
        baseUrl = config.baseUrl
        token   = config.accessToken
    }
}
