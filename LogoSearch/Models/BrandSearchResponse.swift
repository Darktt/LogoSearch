//
//  BrandSearchResponse.swift
//  LogoSearch
//
//  Created by Darktt on 2025/2/6.
//

import Foundation
import JsonProtection

public
typealias BrandSearchResponse = Array<LogoInfo>

// MARK: - LogoInfo -

public
struct LogoInfo
{
    // MARK: - Properties -
    
    public
    let name: String?
    
    public
    let domain: String?
    
    @URLProtection
    public private(set)
    var imageUrl: URL?
}

extension LogoInfo: Decodable
{
    enum CodingKeys: String, CodingKey
    {
        case name
        
        case domain
        
        case imageUrl = "logo_url"
    }
}
