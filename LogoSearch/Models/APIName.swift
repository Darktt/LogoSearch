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
    
    private
    init(_ urlString: String)
    {
        self.url = URL(string: urlString)!
    }
}
