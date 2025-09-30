//
//  APIKey.swift
//  LogoSearch
//
//  Created by Darktt on 2025/2/6.
//

import Foundation
import Configuration

struct APIKey
{
    // MARK: - Properties -
    
    public static
    var publicKey: String {
        
        Config().publicKey
    }
    
    public static
    var secretKey: String {
        
        Config().secretKey
    }
}
