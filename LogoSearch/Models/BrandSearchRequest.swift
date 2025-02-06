//
//  BrandSearchRequest.swift
//  LogoSearch
//
//  Created by Darktt on 2025/2/6.
//

import Foundation
import SwiftExtensions

public
struct BrandSearchRequest: APIRequest
{
    public
    typealias Response = BrandSearchResponse
    
    // MARK: - Properties -
    
    public private(set)
    var apiName: APIName = APIName.search
    
    public private(set)
    var method: HTTPMethod = .get
    
    public
    var parameters: Dictionary<AnyHashable, Any>?
    
    public
    var headers: Array<SwiftExtensions.HTTPHeader>? = [.authorization(token: APIKey.secretKey, type: .bearer)]
    
    // MARK: - Methods -
    
    public
    init(keyword: String)
    {
        let parameters: Dictionary<String, Any> = ["q": keyword]
        
        self.parameters = parameters
    }
}
