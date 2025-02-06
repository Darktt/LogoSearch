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
    let domain: URL?
    
    @URLProtection
    public private(set)
    var image: URL?
}

extension LogoInfo: Decodable
{
    enum CodingKeys: String, CodingKey
    {
        case name
        
        case domain
        
        case image = "logo_url"
    }
}
