//
//  APIName.swift
//
//  Created by Darktt on 2023/7/4.
//

import Foundation

public
struct APIName
{
    // MARK: - Properties -
    
    public static
    var search: APIName = APIName("https://api.logo.dev/search")
    
    public
    var url: URL
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public static
    func image(with domain: String) -> APIName
    {
        let urlString = "https://img.logo.dev/\(domain)"
        
        return APIName(urlString)
    }
    
    public static
    func ticker(with stockTicker: String) -> APIName
    {
        let urlString = "https://img.logo.dev/ticker/\(stockTicker)"
        
        return APIName(urlString)
    }
    
    private
    init(_ urlString: String)
    {
        self.url = URL(string: urlString)!
    }
}
