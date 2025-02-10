//
//  Logger.swift
//
//  Created by Darktt on 18/10/18.
//  Copyright © 2018 Darktt. All rights reserved.
//

import Foundation

public
struct Logger: LoggerCompatible
{
    public
    let filePrefix: String
    
    public
    let folderName: String
    
    public
    init(filePrefix: String = "", folderName: String)
    {
        self.filePrefix = filePrefix
        self.folderName = folderName
    }
    
    public
    func callAsFunction(level: LoggerLevel, _ message: String)
    {
        self.write("【\(level)】 " + message)
    }
}

private
extension Logger
{
    func write(_ string: String)
    {
        if string.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return
        }
        
        print(string)
        
        #if os(OSX)
        
        let paths: Array<String> = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        #else
        
        let paths: Array<String> = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        
        #endif
        
        let path: String = paths.first!
        let date = Date()
        let dateFormatter = DateFormatter.sharedForLog
        dateFormatter.dateFormat = "YYYYMMdd"
        
        let fileName: String = self.filePrefix + dateFormatter.string(from: date) + ".txt"
        let folderName: String = self.folderName
        let filePath: String = path._appendingPathComponent("/" + folderName + "/" + fileName)
        
        let fileManager = FileManager.default
        
        // Check file is exists.
        if !fileManager.fileExists(atPath: filePath) {
            
            let created: Bool = fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
            
            if !created {
                
                let directoryPath: String = path._appendingPathComponent("/" + folderName)
                
                do {
                    
                    try fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: false, attributes: nil)
                    fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
                    
                } catch {
                    
                    print(error)
                }
            }
        }
        
        // Write data to file.
        if let fileHandle = FileHandle(forWritingAtPath: filePath) {
            
            autoreleasepool {
                
                let stringData: String = string + "\n"
                let appentData: Data = stringData.data(using: .utf8)!
                
                fileHandle.seekToEndOfFile()
                fileHandle.write(appentData)
                fileHandle.synchronizeFile()
                fileHandle.closeFile()
            }
        }
    }
}

// MARK: - Extensions -

private extension DateFormatter
{
    static let sharedForLog: DateFormatter = DateFormatter()
}

private extension String
{
    var _lastPathComponent: String {
        
        let aString = self as NSString
        
        return aString.lastPathComponent
    }
    
    func _appendingPathComponent(_ pathComponent: String) -> String
    {
        let string: NSString = self as NSString
        
        return string.appendingPathComponent(pathComponent)
    }
}
