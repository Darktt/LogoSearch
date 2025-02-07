//
//  LogoSearchState.swift
//  LogoSearch
//
//  Created by Darktt on 2025/2/6.
//

import Foundation
import UIKit.UIImage

public
struct LogoSearchState
{
    // MARK: - Properties -
    
    public private(set)
    var logoInfos: Array<LogoInfo> = []
    
    public
    var error: LogoSearchError?
    
    public private(set)
    var cachedImages: Dictionary<IndexPath, UIImage> = [:]
    
    public
    var logoImage: UIImage?
}

public
extension LogoSearchState
{
    mutating
    func updateLogoInfos(_ logoInfos: Array<LogoInfo>)
    {
        self.logoInfos = logoInfos
        self.cachedImages.removeAll()
    }
    
    mutating
    func updateCachedImage(_ image: UIImage?, at indexPath: IndexPath)
    {
        self.cachedImages[indexPath] = image
    }
}

