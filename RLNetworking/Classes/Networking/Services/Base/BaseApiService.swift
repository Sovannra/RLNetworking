//
//  BaseApiService.swift
//  ios-app-milio
//
//  Created by IG_Se7enzZ on 8/15/20.
//  Copyright © 2020 Core-MVVM. All rights reserved.
//

import Foundation

protocol ApiService {
    associatedtype ProviderType: TargetType
}

/// All the api request services need to implement from BaseApiService
/// <T>:  is a Provider Type or Resource Type

class BaseApiService<T>: ApiService where T: TargetType {
    
    private var task: URLSessionTask?
    
    typealias ProviderType = T
    
    private var session: URLSessionProtocol
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    func request<T>(service: ProviderType, model: T.Type, completion: @escaping (NetworkResponse<T>) -> ()) where T: Codable {
        
        if !Connectivity.isConnectedToNetwork(){
            let mData = Data()
            completion(.failure(mData))
            return
        }
        do {
            let request = try self.buildRequest(from: service)
//            NetworkLogger.log(request: request)
            
            task = session.dataTask(request: request) { (data, response, error) in
                
                let httpResponse = response as? HTTPURLResponse
                
                do {
                    if data != nil {
//                        let jsonError = try JSONDecoder().decode(T.self, from: data!)
                        self.handleDataResponse(data: data, response: httpResponse, completion: completion)
                    }else{
                        let mData = Data()
                        completion(.failure(mData))
                    }
                    
                }
                
            }
            
            task?.resume()
            
        } catch {
            fatalError()
        }
        
    }
    
    func cancel() {
        self.task?.cancel()
    }

    
    fileprivate func buildRequest(from providerType: ProviderType) throws -> URLRequest {
        
        var request = URLRequest(url: providerType.baseUrl.appendingPathComponent(providerType.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        
        request.httpMethod = providerType.method.rawValue
        
        do {
            switch providerType.task {
                
            case .requestPlain:
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                break
            case .requestParameters(bodyParameters: let bodyParameters,
                                    bodyEncoding: let bodyEncoding,
                                    urlParameters: let urlParameters):
                
                self.requestHeaders(service: providerType, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request)
                
                
            case .requestParametersAndHeaders(bodyParameters: let bodyParameters, bodyEncoding: let bodyEncoding, urlParameters: let urlParameters, additionHeaders: let additionHeaders):
                
                self.addAdditionalHeaders(additionHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request)
                
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func requestHeaders(service: TargetType, request: inout URLRequest) {
        service.headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: Headers?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func handleDataResponse<T: Codable>(data: Data?, response: HTTPURLResponse?, completion: (NetworkResponse<T>) -> ()) {
        
//        guard error != nil else {
//            return completion(.failure(error!))
//        }
        guard let response = response else {
            return completion(.failure(data))
        }
        
        switch response.statusCode {
        case 200...299:
            do {
                // JsonDecoder Successs
                guard let data = data else { return }
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
                
                // Catch Error JsonDecoder
            } catch let decodingError as DecodingError {
                switch decodingError {
                    
                case .typeMismatch(let type, let context):
                    handlePrintingDecodingError(type: type, rawString: "mismatch", context: context)
                    
                case .valueNotFound(let value, let context):
                    handlePrintingDecodingError(type: value, rawString: "not found", context: context)
                    
                case .keyNotFound(let key, let context):
                    handlePrintingDecodingError(type: key, rawString: "not found", context: context)
                case .dataCorrupted(let context):
                    handlePrintingDecodingError(type: "", rawString: "", context: context)
                @unknown default:
                    return
                }
                completion(.failure(data))
            } catch {
                completion(.failure(data))
                print("Default Error", error)
            }
            
        default:
            completion(.failure(data))
        }
    }
    
    private func handlePrintingDecodingError(type: Any, rawString: String, context: DecodingError.Context) {
        print("\(type) \(rawString): ", context.debugDescription)
        print("codingPath: ", context.codingPath)
    }
    
    func decode<T>(modelType: T.Type, data: Data?) -> T? where T : Decodable {
        do {
            let jsonError = try JSONDecoder().decode(modelType.self, from: data!)
            return jsonError
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
