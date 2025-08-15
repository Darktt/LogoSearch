//
//  APIRequest.swift
//
//  Created by Darktt on 2025/8/12.
//  Copyright © 2023 Darktt. All rights reserved.
//

import Foundation

#if canImport(SwiftExtensions)
    
import SwiftExtensions

#endif

#if canImport(SwiftPlayground)

import SwiftPlayground

#endif

public
protocol APIRequest
{
    associatedtype Response: JsonDecodable
    
    typealias Result = Swift.Result<Response, any Error>
    
    // MARK: - Properties -
    
    var apiName: APIName { get }
    
    var method: HTTPMethod { get }
    
    var parameters: Dictionary<AnyHashable, Any>? { get }
    
    var headers: Array<HTTPHeader>? { get }
}

extension APIRequest
{
    var urlRequest: URLRequest {
        
        var url: URL = self.apiName.url
        
        if self.method == .get {
            
            url._append(queryItems: self.parameters?.queryItems() ?? [])
        }
        
        var request = URLRequest(url: url)
        request.method = self.method
        request.allHTTPHeaderFields = self.headers?.dictionary()
        
        return request
    }
}

// MARK: - Private Extensions -

fileprivate
extension URL
{
    mutating
    func _append(queryItems: Array<URLQueryItem>)
    {
        if #available(iOS 16.0, *) {
            
            self.append(queryItems: queryItems)
            return
        }
        
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        
        self = urlComponents?.url ?? self
    }
}

fileprivate
extension Dictionary<AnyHashable, Any>
{
    func queryItems() -> Array<URLQueryItem>
    {
        self.compactMap {
            
            (key, value) in
            
            guard let keyString = key as? String else {
                
                return nil
            }
            
            let valueString = "\(value)"
            let item = URLQueryItem(name: keyString, value: valueString)
            
            return item
        }
    }
}
