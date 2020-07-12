//
//  FVFile.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/12/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI

public class FVFile: NSObject {
    public var displayName: String
    public var isDirectory: Bool
    public let fileExtension: String?
    public let fileName: String
    public let filePath: NSURL
    public let filePathURL: URL
    public let type: FVFileType
    
    
    init(filePath: NSURL) {
        self.filePath    = filePath

        var isDirectory = false
        
        var filePathString = self.filePath.absoluteString
        filePathString = filePathString!.replacingOccurrences(of: "file://", with: "")
        var isDir : ObjCBool = false
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePathString!, isDirectory:&isDir) {
            if (isDir.boolValue) {
                isDirectory = true
            }
        }
    
        filePathURL = filePath.absoluteURL!
        
        self.isDirectory = isDirectory
        
        if self.isDirectory {
            self.fileExtension  = nil
            self.type           = .Directory
        }
        else {
            self.fileExtension = self.filePath.pathExtension
            
            self.type = .Default
        }
        self.fileName = self.filePath.lastPathComponent!
        self.displayName = filePath.lastPathComponent ?? String()

    }
}

