//
//  AuthenticateResource.swift
//  RLNetworking_Example
//
//  Created by Sovannra on 16/2/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import RLNetworking

enum AuthenticateResource {
    case loginWithEmail(email: String, password: String)
}

extension AuthenticateResource: TargetType {
        
    var path: String {
        switch self {
        case .loginWithEmail:
            return "core/api/basic/1.1/auth/email"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loginWithEmail:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .loginWithEmail(let email, let password):
            let bodyParams = ["email":email, "password":password]
            return .requestParameters(bodyParameters: bodyParams, bodyEncoding: .jsonEncoding, urlParameters: nil)
        }
    }
    
    var headers: Headers {
        switch self {
        case .loginWithEmail:
            return getHeader()
        }
    }
    
}
