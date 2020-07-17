//
//  FVFile.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/12/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI

public class FVFile: Identifiable, Hashable {
    public static func == (lhs: FVFile, rhs: FVFile) -> Bool {
        return lhs.displayName == rhs.displayName && lhs.isDirectory == rhs.isDirectory && lhs.fileExtension == rhs.fileExtension && lhs.fileName == rhs.fileName && lhs.filePath.absoluteString == rhs.filePath.absoluteString
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(displayName)
    }
    
    
    private enum CodingKeys: String, CodingKey {
        case displayName = "displayName"
        case isDirectory = "isDirectory"
        case fileExtension = "fileExtension"
        case fileName = "fileName"
        case id = "id"
        case filePath = "filePath"
    }
    
    func encode(from encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.displayName, forKey: .displayName)
        try container.encode(self.isDirectory, forKey: .isDirectory)
        try container.encode(self.fileExtension, forKey: .fileExtension)
        try container.encode(self.fileName, forKey: .fileName)
        try container.encode(self.filePath, forKey: .filePath)
        try container.encode(self.id, forKey: .id)
    }
    
    required public init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try values.decode(String.self, forKey: .displayName)
        isDirectory = try values.decode(Bool.self, forKey: .isDirectory)
        do {
            fileExtension = try values.decode(String.self, forKey: .fileExtension)
        } catch {
            fileExtension = nil
        }
        fileName = try values.decode(String.self, forKey: .fileName)
        filePath = try values.decode(URL.self, forKey: .filePath)
        id = try values.decode(String.self, forKey: .id)
    }
    
    public var displayName: String
    public var isDirectory: Bool
    public let fileExtension: String?
    public let fileName: String
    public let id: String
    public let filePath: URL
    
    
    init(filePath: NSURL) {
        self.filePath    = filePath as URL

        var isDirectory = false
        
        var filePathString = self.filePath.absoluteString
        filePathString = filePathString.replacingOccurrences(of: "file://", with: "")
        var isDir : ObjCBool = false
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePathString, isDirectory:&isDir) {
            if (isDir.boolValue) {
                isDirectory = true
            }
        }
        
        self.isDirectory = isDirectory
        
        if self.isDirectory {
            self.fileExtension  = nil
        }
        else {
            self.fileExtension = self.filePath.pathExtension
        }
        self.fileName = self.filePath.lastPathComponent
        self.id = self.filePath.absoluteString
        self.displayName = filePath.lastPathComponent ?? String()

    }
}

