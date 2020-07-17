//
//  UserSettings.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/12/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class SimpleSchemeState: FluxState, ObservableObject {
    
//    enum CodingKeys: String, CodingKey {
//        case files
//        case currentFile
//        case fileToRename
//        case currentFileContents
//        case consoleOutput
//        case currentDirectory
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(files, forKey: .files)
//        try container.encode(currentFile, forKey: .currentFile)
//        try container.encode(fileToRename, forKey: .fileToRename)
//        try container.encode(currentFileContents, forKey: .currentFileContents)
//        try container.encode(currentDirectory, forKey: .currentDirectory)
//        try container.encode(consoleOutput, forKey: .consoleOutput)
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        files = try container.decode([FVFile].self, forKey: .files)
//        currentFile = try container.decode(FVFile.self, forKey: .currentFile)
//        fileToRename = try container.decode(FVFile.self, forKey: .fileToRename)
//        currentDirectory = try container.decode(URL.self, forKey: .currentDirectory)
//        currentFileContents = try container.decode(String.self, forKey: .currentFileContents)
//        consoleOutput = try container.decode(String.self, forKey: .consoleOutput)
//        pipe = Pipe()
//      }
    
//    static func == (lhs: AppState, rhs: AppState) -> Bool {
//        return lhs.currentFile == rhs.currentFile && lhs.fileToRename == rhs.fileToRename && lhs.currentFileContents == rhs.currentFileContents && lhs.consoleOutput == rhs.consoleOutput
//    }
    
    @Published var currentFileContents: String = ""
    @Published var consoleOutput: String = ""
    @Published var isPipeCreated: Bool = false
    @Published var currentFile: FVFile? = nil
    @Published var fileToRename: FVFile? = nil
    private let fileManager = FileManager.default
    let objectWillChange = ObservableObjectPublisher()
    @Published var files = [FVFile]() {
        didSet {
            objectWillChange.send()
        }
        willSet {
            objectWillChange.send()
        }
    }
    @Published var currentDirectory: URL = URL(string: "./")! {
        didSet {
            self.files = []
            
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            
            if (self.currentDirectory.standardizedFileURL != documentsDirectory.standardizedFileURL) {
                var downOneURL = self.currentDirectory
                downOneURL.appendPathComponent("..")
                downOneURL = downOneURL.standardizedFileURL
                let backPath = FVFile(filePath: downOneURL as NSURL)
                backPath.isDirectory = true
                backPath.displayName = ".."
                self.files = [backPath]
            }
            
            let filePaths = try! self.fileManager.contentsOfDirectory(at: self.currentDirectory, includingPropertiesForKeys: [], options: [])
            
            for filePath in filePaths {
                let file = FVFile(filePath: filePath as NSURL)
                if !file.displayName.isEmpty {
                    self.files.append(file)
                }
            }
            
            var dirs = self.files.filter { $0.isDirectory }
            self.files = self.files.filter { !$0.isDirectory }
            dirs.sort(by: {$0.displayName < $1.displayName})

            self.files.sort(by: {$0.displayName < $1.displayName})
            
            var sorted:[FVFile] = [FVFile]()
            sorted.append(contentsOf: dirs)
            sorted.append(contentsOf: self.files)
            self.files = sorted
        }
    }
}
