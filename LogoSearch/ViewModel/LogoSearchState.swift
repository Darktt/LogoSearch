//
//  LogoSearchState.swift
//  LogoSearch
//
//  Created by Eden on 2025/2/6.
//

import Foundation

public
struct LogoSearchState
{
    // MARK: - Properties -
    
    public private(set)
    var logInfos: Array<LogoInfo> = []
    
    public
    var error: LogoSearchError?
}

public
extension LogoSearchState
{
    mutating
    func updateLogoInfos(_ logInfos: Array<LogoInfo>)
    {
        self.logInfos = logInfos
    }
}

