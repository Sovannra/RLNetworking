//
//  AuthenticateService.swift
//  RLNetworking_Example
//
//  Created by Sovannra on 16/2/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import RLNetworking

class AuthenticateService: BaseApiService<AuthenticateResource> {
    static let shared = AuthenticateService()

    func loginWithEmail(email: String, password: String, success: @escaping(LoginModel) -> Void, failure: @escaping(APIError?) -> Void) {
        request(service: .loginWithEmail(email: email, password: password), model: LoginModel.self) { result in
            switch result {
            case .success(let res):
                if res.status == 1 {
                    success(res)
                } else {
                    failure(APIError(statusCode: res.status, message: res.message))
                }
            case .failure(let err):
                failure(self.decode(modelType: APIError.self, data: err))
            }
        }
    }
}
