//
//  ApiMiddware.swift
//  StackExchangeDemo
//
//  Created by Darktt on 2024/6/28.
//

import Foundation

@MainActor
public
let ApiMiddware: Middleware<LogoSearchState, LogoSearchAction> = {
    
    store in
    
    {
        next in
        
        {
            action in
            
            if case let LogoSearchAction.search(request) = action {
                
                Task {
                    
                    let newAction: LogoSearchAction = await searchRequest(with: request)
                    
                    next(newAction)
                }
                return
            }
            
            next(action)
        }
    }
}

@MainActor
private
func apiRequest<Request>(_ request: Request) async throws -> Request.Response where Request: APIRequest
{
    let apiHandler = APIHandler.shared
    let response: Request.Response = try await apiHandler.sendRequest(request)
    
    return response
}

private
func searchRequest(with request: BrandSearchRequest) async -> LogoSearchAction
{
    do {
        
        let response: BrandSearchResponse = try await apiRequest(request)
        
        let newAction = LogoSearchAction.searchResult(response)
        
        return newAction
    } catch {
        
        let newAction = LogoSearchAction.fetchApiError(error)
        
        return newAction
    }
}
