//
//  LogoSearchAction.swift
//  LogoSearch
//
//  Created by Darktt on 2025/2/6.
//

import Foundation
import UIKit.UIImage

public
enum LogoSearchAction
{
    case search(BrandSearchRequest)
    
    case searchResult(Array<LogoInfo>)
    
    case fetchApiError(any Error)
    
    case fetchImage(URL, IndexPath)
    
    case fetchImageResponse(UIImage?, IndexPath)
    
    case error(LogoSearchError)
}
