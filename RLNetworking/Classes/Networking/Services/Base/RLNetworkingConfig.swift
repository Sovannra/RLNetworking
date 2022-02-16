//
//  RLNetworkingConfig.swift
//  RLNetworking
//
//  Created by Sovannra on 16/2/22.
//

import Foundation

public struct RLNetworkConstant {
    
    /**
     To store BaseUrl value from Enviroment
     This value use in TargetType for base url
     */
    public static var baseUrl: String = ""
    /**
     To store user access token
     This value use in TargetType for authorization
     */
    public static var token: String   = ""
    /**
     This value use for enable/disable network logger
     */
    public static var enableLogger: Bool = false
}
