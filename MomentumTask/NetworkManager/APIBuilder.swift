//
//  APIBuilder.swift
//  MomentumTask
//
//  Created by Salma on 20/11/2024.
//

import Foundation

class APIBuilder {
    private var url: URL?
    private var method: HTTPMethod
    private var headers: [String: String]
    private var parameters: [String: String] = [:]
    private var httpBodyParameters: Data?
    
    init() {
        method = .GET
        headers = ["Content-Type": "application/json"]
    }
    
    func setUrl(hostUrl: String) -> APIBuilder {
        guard let url = URL(string: hostUrl) else {
            fatalError("Invalid url")
        }
        self.url = url
        return self
    }
    
    func setMethod(method: HTTPMethod) -> APIBuilder {
        self.method = method
        return self
    }
    
    func setHeaders(key: String, value: String) -> APIBuilder {
        headers[key] = value
        return self
    }
    
    func setQueryParameters(key: String, value: String) -> APIBuilder {
        parameters[key] = value
        return self
    }
    
    func setBodyParameters<T: Encodable>(body: T) -> APIBuilder {
        var httpBody: Data?
        do {
            httpBody = try JSONSerialization.data(withJSONObject: body.toDictionary(), options: [])
        } catch {
            print("Error setting body parameters")
        }
        httpBodyParameters = httpBody
        return self
    }
    
    func build() -> URLRequest {
        guard let url = url else {
            fatalError("Invalid url")
        }
        var component = URLComponents(string: url.absoluteString)
        if !parameters.isEmpty {
            component?.queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let component, let url = component.url else { fatalError() }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = httpBodyParameters
        for header in headers {
          urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }
        return urlRequest
    }
    
}
