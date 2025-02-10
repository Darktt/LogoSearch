//
//  Log.swift
//
//  Created by Darktt on 23/6/16.
//

import Foundation

@MainActor
public
struct Log
{
    // MARK: - Properties -
    
    public static
    var logger: any LoggerCompatible {
        
        set {
            
            Log.current.logger(newValue)
        }
        
        get {
            
            Log.current.v.logger
        }
    }
    
    public static
    var v: Verbose {
        
        Log.current.v
    }
    
    public static
    var d: Debug {
        
        Log.current.d
    }
    
    public static
    var i: Info {
        
        Log.current.i
    }
    
    public static
    var w: Warning {
        
        Log.current.w
    }
    
    public static
    var e: Error {
        
        Log.current.e
    }
    
    private static
    let current: Log = .init()
    
    private
    let v: Verbose = .init(logger: Log.Logger())
    
    private
    let d: Debug = .init(logger: Log.Logger())
    
    private
    let i: Info = .init(logger: Log.Logger())
    
    private
    let w: Warning = .init(logger: Log.Logger())
    
    private
    let e: Error = .init(logger: Log.Logger())
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    private
    init() {}
}

// MARK: - Private Methods -

private
extension Log
{
    private
    func logger(_ logger: any LoggerCompatible)
    {
        self.v.logger = logger
        self.d.logger = logger
        self.i.logger = logger
        self.w.logger = logger
        self.e.logger = logger
    }
}

// MARK: Log.Logger

fileprivate
extension Log
{
    struct Logger: LoggerCompatible
    {
        fileprivate
        init () { }
        
        fileprivate
        func callAsFunction(level: LoggerLevel, _ message: String)
        {
            print("【\(level)】 " + message)
        }
    }
}

// MARK: Log.Operator

public
extension Log
{
    @MainActor
    class Operator
    {
        fileprivate
        var logger: any LoggerCompatible
        
        fileprivate
        init(logger: any LoggerCompatible)
        {
            self.logger = logger
        }
        
        public
        func callAsFunction(title: String? = nil, message: String, function: String = #function, line: Int = #line)
        {
            fatalError("Implement in subclass.")
        }
    }
}

// MARK: Log.Verbose

public
extension Log
{
    final
    class Verbose: Operator
    {
        public override
        func callAsFunction(title: String? = nil, message: String, function: String = #function, line: Int = #line)
        {
            if let title = title {
                
                self.logger(level: .verbose, function + " [\(line)] " + title + message)
            } else {
                
                self.logger(level: .verbose, function + " [\(line)] " + message)
            }
        }
    }
}

// MARK: Log.Debug

public
extension Log
{
    class Debug: Operator
    {
        public override
        func callAsFunction(title: String? = nil, message: String, function: String = #function, line: Int = #line)
        {
            if let title = title {
                
                self.logger(level: .debug, function + " [\(line)] " + title + message)
            } else {
                
                self.logger(level: .debug, function + " [\(line)] " + message)
            }
        }
    }
}

// MARK: Log.Info

public
extension Log
{
    class Info: Operator
    {
        public override
        func callAsFunction(title: String? = nil, message: String, function: String = #function, line: Int = #line)
        {
            if let title = title {
                
                self.logger(level: .info, function + " [\(line)] " + title + message)
            } else {
                
                self.logger(level: .info, function + " [\(line)] " + message)
            }
        }
    }
}

// MARK: Log.Warning

public
extension Log
{
    class Warning: Operator
    {
        public override
        func callAsFunction(title: String? = nil, message: String, function: String = #function, line: Int = #line)
        {
            if let title = title {
                
                self.logger(level: .warning, function + " [\(line)] " + title + message)
            } else {
                
                self.logger(level: .warning, function + " [\(line)] " + message)
            }
        }
    }
}

// MARK: Log.Error

public
extension Log
{
    class Error: Operator
    {
        public override
        func callAsFunction(title: String? = nil, message: String, function: String = #function, line: Int = #line)
        {
            if let title = title {
                
                self.logger(level: .error, function + " [\(line)] " + title + message)
            } else {
                
                self.logger(level: .error, function + " [\(line)] " + message)
            }
        }
    }
}
