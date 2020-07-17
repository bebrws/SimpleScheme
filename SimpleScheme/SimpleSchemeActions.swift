//
//  SimpleSchemeActions.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/14/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation

struct SimpleSchemeActions {
    struct setFileToRename: Action {
        let file: FVFile
    }
    struct setCurrentFile: Action {
        let file: FVFile
    }
    struct setCurrentDirectory: Action {
        let directory: URL
    }
    struct setCurrentFileContents: Action {
        let contents: String
    }
    struct setConsoleOutput: Action {
        let output: String
    }
    struct setIsPipeCreated: Action {
        let isCreated: Bool
    }
    
    struct deleteFileOrFolder: AsyncAction {
        var filePath: URL
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            let state = state as! SimpleSchemeState
            do {
                try FileManager.default.removeItem(at: filePath)
            } catch {
                print(error.localizedDescription)
            }
            
            if (state.currentFile?.filePath == filePath) {
                state.currentFile = nil
            }
            
            dispatch(SimpleSchemeActions.updateFileListings())
            
        }
    
    }
    
    struct createFile: AsyncAction {
        var newName: String
        var hideCallback: () -> Void
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            let state = state as! SimpleSchemeState
            
            let newFileFullPath = state.currentDirectory.appendingPathComponent(newName)
            var fileString = newFileFullPath.absoluteString
            fileString = fileString.replacingOccurrences(of: "file://", with: "")
            if !FileManager.default.fileExists(atPath: fileString) {
                FileManager.default.createFile(atPath: fileString, contents: "".data(using: .utf8), attributes: nil)
            }
            
            dispatch(SimpleSchemeActions.updateFileListings())
            hideCallback()
            
        }
    
    }
    
    struct createDirectory: AsyncAction {
        var newName: String
        var hideCallback: () -> Void
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            let state = state as! SimpleSchemeState
            
            let newDirFullPath = state.currentDirectory.appendingPathComponent(newName)
            var newDirString = newDirFullPath.absoluteString
            newDirString = newDirString.replacingOccurrences(of: "file://", with: "")

            if !FileManager.default.fileExists(atPath: newDirString) {
                do {
                    try FileManager.default.createDirectory(atPath: newDirString, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            dispatch(SimpleSchemeActions.updateFileListings())
            hideCallback()
        }
    }
    
    struct updateFileListings: AsyncAction {
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            let state = state as! SimpleSchemeState
            
            state.files = []
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]

            if (state.currentDirectory.standardizedFileURL != documentsDirectory.standardizedFileURL) {
                var downOneURL = state.currentDirectory
                downOneURL.appendPathComponent("..")
                downOneURL = downOneURL.standardizedFileURL
                let backPath = FVFile(filePath: downOneURL as NSURL)
                backPath.isDirectory = true
                backPath.displayName = ".."
                state.files = [backPath]
            }

            let filePaths = try! FileManager.default.contentsOfDirectory(at: state.currentDirectory, includingPropertiesForKeys: [], options: [])

            for filePath in filePaths {
                let file = FVFile(filePath: filePath as NSURL)
                if !file.displayName.isEmpty {
                    state.files.append(file)
                }
            }

            var dirs = state.files.filter { $0.isDirectory }
            state.files = state.files.filter { !$0.isDirectory }
            dirs.sort(by: {$0.displayName < $1.displayName})

            state.files.sort(by: {$0.displayName < $1.displayName})

            var sorted:[FVFile] = [FVFile]()
            sorted.append(contentsOf: dirs)
            sorted.append(contentsOf: state.files)
            state.files = sorted
            
        }
    }
    
    struct renameFileOrDirectory: AsyncAction {
        var newName: String
        var hideCallback: () -> Void
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            let state = state as! SimpleSchemeState
            
            var currentPath = state.fileToRename!.filePath.absoluteString
            currentPath = currentPath.replacingOccurrences(of: "file://", with: "")
            var newPath = state.fileToRename!.filePath.absoluteString
            newPath = newPath.replacingOccurrences(of: "file://", with: "")
            newPath = String(newPath[..<newPath.lastIndex(of: "/")!])
            newPath += "/" + newName

            print("Renaming file/folder from:")
            print(currentPath)
            print("to:")
            print(newPath)

            do {
                try FileManager.default.moveItem(atPath: currentPath, toPath: newPath)
            } catch {
                print(error.localizedDescription)
            }
            if (state.currentFile!.filePath.absoluteString.contains(state.fileToRename!.filePath.absoluteString)) {
                state.currentFile = nil
            }
            hideCallback()
            
            dispatch(SimpleSchemeActions.updateFileListings())
        }
    }
}


