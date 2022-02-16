# RLNetworking

[![CI Status](https://img.shields.io/travis/Sovannra/RLNetworking.svg?style=flat)](https://travis-ci.org/Sovannra/RLNetworking)
[![Version](https://img.shields.io/cocoapods/v/RLNetworking.svg?style=flat)](https://cocoapods.org/pods/RLNetworking)
[![License](https://img.shields.io/cocoapods/l/RLNetworking.svg?style=flat)](https://cocoapods.org/pods/RLNetworking)
[![Platform](https://img.shields.io/cocoapods/p/RLNetworking.svg?style=flat)](https://cocoapods.org/pods/RLNetworking)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Features
* URL / JSON Parameter Encoding
* Network Reachability
* Network Logger

## Requirements
* iOS 12.0+
* Swift 4 & 5

## Installation

RLNetworking is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RLNetworking'
```
## Getting Started
#### Initialization and presentation

```swift

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

```
```swift

import RLNetworking

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
    RLNetworkConstant.baseUrl = "\(Environment.BASE_URL)"
    RLNetworkConstant.token   = "\(Auth().accessToken)"
        
    return true
}
    
```
```swift

import RLNetworking

enum AuthenticateResource {
    case loginWithEmail(email: String, password: String)
}

extension AuthenticateResource: TargetType {
    
    var baseUrl: URL {
        return URL(string: "\(Environment.BASE_URL)")!
    }
    
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

```
```swift

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

```

## Author

Sovannra, sovannrakong@gmail.com

## License

RLNetworking is available under the MIT license. See the LICENSE file for more info.
