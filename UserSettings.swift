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

class UserSettings: ObservableObject {
    @Published var currentFileContents: String = ""
    @Published var consoleOutput: String = ""
    @Published var pipe: Pipe? = nil
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
    @Published var currentDir: URL = URL(string: "./")! {
        didSet {
            self.files = []
            
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            
            if (self.currentDir.standardizedFileURL != documentsDirectory.standardizedFileURL) {
                var downOneURL = self.currentDir
                downOneURL.appendPathComponent("..")
                downOneURL = downOneURL.standardizedFileURL
                let backPath = FVFile(filePath: downOneURL as NSURL)
                backPath.isDirectory = true
                backPath.displayName = ".."
                self.files = [backPath]
            }
            
            let filePaths = try! self.fileManager.contentsOfDirectory(at: self.currentDir, includingPropertiesForKeys: [], options: [])
            
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
