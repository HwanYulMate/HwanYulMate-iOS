//
//  Endpoint.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/13/25.
//

import Foundation

enum HTTPMethodType: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

protocol Endpoint {
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var headers: [String: String]? { get }
    var method: HTTPMethodType { get }
    var path: String { get }
    var queryParametersEncodable: Encodable? { get }
    var bodyParametersEncodable: Encodable? { get }
    var bodyEncoder: BodyEncoder { get }
    var responseDecoder: ResponseDecoder { get }
    
    func asURLRequest() throws -> URLRequest
}

extension Endpoint {
    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(
            url: baseURL.appending(path: path),
            resolvingAgainstBaseURL: false
        )
        
        if let queryEncodable = queryParametersEncodable {
            let queryDictionary = try queryEncodable.toDictionary() ?? [:]
            var queryItems = [URLQueryItem]()
            
            queryDictionary.forEach {
                queryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
            }
            
            urlComponents?.queryItems = queryItems.isEmpty ? nil : queryItems
        }
        
        guard let url = urlComponents?.url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let bodyEncodable = bodyParametersEncodable {
            let bodyDictionary = try bodyEncodable.toDictionary() ?? [:]
            
            if !bodyDictionary.isEmpty {
                request.httpBody = bodyEncoder.encode(bodyDictionary)
            }
        }
        
        return request
    }
}

protocol BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data?
}

struct JSONBodyEncoder: BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

struct JSONResponseDecoder: ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        
        return jsonData as? [String: Any]
    }
}
