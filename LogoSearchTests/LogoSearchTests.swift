//
//  LogoSearchTests.swift
//  LogoSearchTests
//
//  Created by Darktt on 2025/2/6.
//

import Testing
@testable import LogoSearch

struct LogoSearchTests
{
    @Test
    func testSendSearchRequest() async throws
    {
        let request = BrandSearchRequest(keyword: "Google")
        let apiHandler = APIHandler.shared
        let response: BrandSearchResponse = try await apiHandler.sendRequest(request)
        
        #expect(response.first?.name == "Google")
    }
    
    @Test
    func testSearchNoResult() async throws
    {
        let request = BrandSearchRequest(keyword: "darktt")
        let apiHandler = APIHandler.shared
        let response: BrandSearchResponse = try await apiHandler.sendRequest(request)
        
        #expect(response.count == 0)
    }
}
