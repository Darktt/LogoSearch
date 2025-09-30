//
//  Config.swift
//  LogoSearch
//
//  Created by Eden on 2025/9/30.
//

import Foundation
import Configuration

public
struct Config
{
    // MARK: - Properties -
    
    public
    var publicKey: String {
        
        self.reader.string(forKey: "publicKey", default: "")
    }
    
    public
    var secretKey: String {
        
        self.reader.string(forKey: "secretKey", default: "")
    }
    
    private
    let reader: ConfigReader
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public
    init()
    {
        let provider = InMemoryProvider(values: ["publicKey": "", "secretKey": ""])
        
        let reader = ConfigReader(providers: [provider])
        
        self.reader = reader
    }
}
