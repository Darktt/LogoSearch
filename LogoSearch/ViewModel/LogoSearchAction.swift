//
//  LogoSearchAction.swift
//  LogoSearch
//
//  Created by Eden on 2025/2/6.
//

import Foundation
import UIKit.UIImage

public
enum LogoSearchAction
{
    case search(BrandSearchRequest)
    
    case searchResult(Array<LogoInfo>)
    
    case fetchApiError(any Error)
    
    case fetchImage(URL)
    
    case fetchImageResponse(UIImage?)
    
    case error(LogoSearchError)
}
