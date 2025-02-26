//
//  LogoSearchStore.swift
//  LogoSearch
//
//  Created by Darktt on 2025/2/6.
//

import Foundation

@MainActor
private
func kReducer(state: LogoSearchState, action: LogoSearchAction) -> LogoSearchState {
    
    var newState = state
    newState.error = nil
    
    switch action {
        
        case let .searchResult(logoInfos):
            newState.updateLogoInfos(logoInfos)
        
        case let .fetchImageResponse(image, indexPath):
            newState.updateCachedImage(image, at: indexPath)
        
        case let .fetchLogoImageResponse(image):
            newState.logoImage = image
        
        case .cleanLogoImageCache:
            newState.logoImage = nil
        
        case let .error(error):
            newState.error = error
        
        default:
            break
    }
    
    return newState
}

public
typealias LogoSearchStore = Store<LogoSearchState, LogoSearchAction>

@MainActor
let kLogoSearchStore = LogoSearchStore(initialState: LogoSearchState(),
                                                  reducer: kReducer,
                                              middlewares: [
                                                                ApiMiddware,
                                                                ImageLoaderMiddware,
                                                                ErrorMiddware
                                                            ]
                                            )
