//
//  NetworkConstant.swift
//  Pods-RLNetworking_Example
//
//  Created by Sovannra on 16/2/22.
//

import Foundation


public protocol RLNetworkConfig: AnyObject {
    
    /**
     To store BaseUrl value from Enviroment
     This value use in TargetType for base url
     */
    var baseUrl: String { get }
    
    /**
     To store user access token
     This value use in TargetType for authorization
     */
    var accessToken: String { get }
    
}

public struct RLNetworkingConstant {
    
    static var baseUrl: String = ""
    static var token: String   = ""
    
    static func config(config: RLNetworkConfig) {
        baseUrl = config.baseUrl
        token   = config.accessToken
    }
}
