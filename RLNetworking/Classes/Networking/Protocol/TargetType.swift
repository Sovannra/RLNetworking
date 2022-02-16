//
//  TargetType.swift
//  RLNetworking
//
//  Created by Sovannra on 16/2/22.
//

import Foundation

/// The protocol used to define the specifications necessary for a `MilioProvider`.

public typealias Headers = [String: String]

public protocol TargetType {
    
    /// The target's base `URL`.
    var baseUrl: URL { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    /// The type of HTTP task to be performed. (request body)
    var task: Task { get }
    
    /// The headers to be used in the request.
    var headers: Headers { get }
    
//    /// The params encoding type
//    var parametersEncoding: ParametersEncoding { get }
}

public extension TargetType {
    
    var baseUrl: URL {
        return URL(string: RLNetworkConstant.baseUrl)!
    }
    
    static private var baseHeader: [String: String] {
        if RLNetworkConstant.token != "" {
            return [
                HTTPHeader.contentType.rawValue: "application/json",
                HTTPHeader.authorization.rawValue: "Bearer \(RLNetworkConstant.token)"
            ]
        }
        return [ HTTPHeader.contentType.rawValue: "application/json"]
    }
    
    func getHeader() -> [String: String] {
        return Self.baseHeader
    }
    
    func noAuthorization() -> [String: String] {
        return [HTTPHeader.contentType.rawValue: "application/json"]
    }
    
}
