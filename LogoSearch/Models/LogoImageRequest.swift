//
//  LogoImageRequest.swift
//  LogoSearch
//
//  Created by Darktt on 2025/2/7.
//

import Foundation

/**
 https://img.logo.dev/disney.com?
   token=pk_FGkiri32QNmZaDZUqtp_UA
   &size=300
   &format=png
   &greyscale=true
   &retina=true
   &fallback=404
 */

public
struct LogoImageRequest
{
    // MARK: - Properties -
    
    public
    var size: Float = 128.0
    
    public
    var format: Format = .jpg
    
    public
    var isGreyscale: Bool = false
    
    public
    var isDarkMode: Bool = false
    
    public
    var isRetina: Bool = true
    
    public
    var fallback: Fallback = .monogram
    
    public
    var url: URL? {
        
        var quertItems: [URLQueryItem] = [
            
            URLQueryItem(name:"token", value: APIKey.publicKey),
            URLQueryItem(name: "size", value: "\(Int(self.size))")
        ]
        
        if self.format == .png {
            
            quertItems.append(contentsOf: [
                
                URLQueryItem(name: "format", value: self.format.rawValue),
                URLQueryItem(name: "theme", value: self.isDarkMode ? "dark" : "light")
            ])
        }
        
        if self.isGreyscale {
                
            let queryItem = URLQueryItem(name: "greyscale", value: "true")
            
            quertItems.append(queryItem)
        }
        
        if self.isRetina {
                
            let queryItem = URLQueryItem(name: "retina", value: "true")
            
            quertItems.append(queryItem)
        }
        
        if self.fallback == .notFound {
                
            let queryItem = URLQueryItem(name: "fallback", value: self.fallback.rawValue)
            
            quertItems.append(queryItem)
        }
        
        var urlComponents = URLComponents(url: self.apiName.url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = quertItems
        let url: URL? = urlComponents?.url
        
        return url
    }
    
    private
    let apiName: APIName
    
    // MARK: - Methods -
    
    public static
    func image(with domain: String) -> LogoImageRequest
    {
        let apiName = APIName.image(with: domain)
        let request = LogoImageRequest(apiName: apiName)
        
        return request
    }
    
    public static
    func ticker(with stockTicker: String) -> LogoImageRequest
    {
        let apiName = APIName.ticker(with: stockTicker)
        let request = LogoImageRequest(apiName: apiName)
        
        return request
    }
}

// MARK: - LogoImageRequest.Format -

public
extension LogoImageRequest
{
    enum Format: String
    {
        case jpg = "JPG (Default)"
        
        case png = "PNG"
    }
}

public
extension LogoImageRequest.Format
{
    static
    var allCases: Array<LogoImageRequest.Format> {
        
        [.jpg, .png]
    }
}

// MARK: - LogoImageRequest.Fallback -

public
extension LogoImageRequest
{
    enum Fallback: String
    {
        case monogram = "Monogram (Default)"
        
        case notFound = "404"
    }
}

extension LogoImageRequest.Fallback
{
    static
    var allCases: Array<LogoImageRequest.Fallback> {
            
        [.monogram, .notFound]
    }
}
