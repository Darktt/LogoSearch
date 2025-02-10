//
//  LoggerCompatible.swift
//
//  Created by Darktt on 23/6/16.
//

import Foundation

public
enum LoggerLevel
{
    case verbose
    
    case debug
    
    case info
    
    case warning
    
    case error
    
    case critical
}

extension LoggerLevel: CustomStringConvertible
{
    public
    var description: String {
        
        let description: String
        
        switch self {
        case .verbose:
            description = "💬 VERBOSE"
            
        case .info:
            description = "ℹ️ INFO"
        
        case .debug:
            description = "🐛 DEBUG"
            
        case .warning:
            description = "⚠️ WARNING"
            
        case .error:
            description = "❌ ERROR"
            
        case .critical:
            description = "☢️ CRITICAL"
        }
        
        return description
    }
}

public
protocol LoggerCompatible: Sendable
{
    func callAsFunction(level: LoggerLevel, _ message: String)
}
