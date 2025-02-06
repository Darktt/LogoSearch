//
//  ImageLoaderMiddware.swift
//  StackExchangeDemo
//
//  Created by Darktt on 2024/7/2.
//

import Foundation
import UIKit

@MainActor
public
let ImageLoaderMiddware: Middleware<LogoSearchState, LogoSearchAction> = {
    
    store in
    
    {
        next in
        
        {
            action in
                
                if case let LogoSearchAction.fetchImage(request) = action {
                    
                    Task {
                        
                        let newAction: LogoSearchAction = await fetchImage(url: request)
                        
                        next(newAction)
                    }
                    return
                }
                
                next(action)
        }
    }
}

func fetchImage(url: URL) async -> LogoSearchAction
{
    do {
        
        let downloader = ImageLoader.shared
        let image: UIImage? = try await downloader.load(with: url)
        
        let newAction = LogoSearchAction.fetchImageResponse(image)
        
        return newAction
        
    } catch {
        
        let newAction = LogoSearchAction.fetchApiError(error)
        
        return newAction
    }
}
