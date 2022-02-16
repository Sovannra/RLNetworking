//
//  LoginModel.swift
//  RLNetworking_Example
//
//  Created by Sovannra on 16/2/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let status: Int
    let data: ResponseLogin
    let message: MessageResponse
    let httpCode: Int
}
// MARK: - DataClass
struct ResponseLogin: Codable {
    let id, accessToken: String?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case accessToken = "access_token"
    }
}

struct APIError: Codable {
    let statusCode: Int
    let message: MessageResponse
}

struct MessageResponse: Codable {
    let code: Int
    let description: DescriptionResponse
}

struct DescriptionResponse: Codable {
    let en: String
    let kh: String
}
