//
//  FilesView.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/12/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI

struct DirectoryPopover: SwiftUI.View {
    @ObservedObject var settings: UserSettings
    @State private var newDirectoryName: String = ""
    var body: some SwiftUI.View {
        VStack {
            Text("Director Creation")
            HStack {
                VStack {
                    TextField("Enter the directory name", text: self.$newDirectoryName)
                }.padding(20)
                VStack {
                    Button(action: {
                        let newDirFullPath = self.settings.currentDir.appendingPathComponent(self.newDirectoryName)
                        var newDirString = newDirFullPath.absoluteString
                        newDirString = newDirString.replacingOccurrences(of: "file://", with: "")
                            
                        if !FileManager.default.fileExists(atPath: newDirString) {
                            do {
                                try FileManager.default.createDirectory(atPath: newDirString, withIntermediateDirectories: true, attributes: nil)
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                        self.settings.currentDir = self.settings.currentDir
                    }) {
                        Text("Create Directory")
                    }
                }.padding(20)
            }
        }
    }
}


struct FilePopover: SwiftUI.View {
    @ObservedObject var settings: UserSettings
    @State private var newFileName: String = ""
    var body: some SwiftUI.View {
        VStack {
            Text("File Creation")
            HStack {
                VStack {
                    TextField("Enter the file name", text: self.$newFileName)
                }.padding(20)
                VStack {
                    Button(action: {
                        let newFileFullPath = self.settings.currentDir.appendingPathComponent(self.newFileName)
                        var fileString = newFileFullPath.absoluteString
                        fileString = fileString.replacingOccurrences(of: "file://", with: "")
                        if !FileManager.default.fileExists(atPath: fileString) {
                            FileManager.default.createFile(atPath: fileString, contents: "".data(using: .utf8), attributes: nil)
                        }
                        self.settings.currentDir = self.settings.currentDir
                    }) {
                        Text("Create File")
                    }
                }.padding(20)
            }
        }
    }
}

struct FileOrDirectoryItemView: SwiftUI.View {
    @ObservedObject var settings: UserSettings
    var file: FVFile
    var setEditorView: () -> Void
    @State private var wasLongPressed: Bool = false
    @State private var showingRenameFileAlert: Bool = false
    @State private var showingRenameDirectoryAlert: Bool = false
    @State private var alertText: String = ""
    
    func createRenameCB(currentFile: FVFile) -> (() -> Void) {
        return {
            print("In rename callback")
            var currentPath = currentFile.filePathURL.absoluteString
            currentPath = currentPath.replacingOccurrences(of: "file://", with: "")
            var newPath = currentFile.filePathURL.absoluteString
            newPath = newPath.replacingOccurrences(of: "file://", with: "")
            newPath = String(newPath[..<newPath.lastIndex(of: "/")!])
            newPath += "/" + self.alertText
            print("Renaming file/folder from:")
            print(currentPath)
            print("to:")
            print(newPath)
            var fileURL = currentFile.filePathURL
            var rv = URLResourceValues()
            rv.name = newPath
            do {
                try fileURL.setResourceValues(rv)
            } catch {
                print(error.localizedDescription)
            }
            
    //                            newPath = newPath.substring(to: newPath.lastIndex(of: "/")!)
    //                            do {
    //                                try FileManager.default.moveItem(atPath: <#T##String#>, toPath: <#T##String#>)
    //                            } catch {
    //                                print(error.localizedDescription)
    //                            }
            self.settings.currentDir = self.settings.currentDir
        }
    }
    
    var body: some SwiftUI.View {
        HStack {
            file.isDirectory ?
                HStack(alignment: .bottom, spacing: 60.0) {
                    Button(action: { }) {
                        HStack {
                            Image(systemName: "folder")
                            Text(file.displayName)
                        }
                    }
                    .frame(width: 160, height: 15, alignment: .leading)
                    .onTapGesture {
                        print("Selected folder")
                        self.settings.currentDir = self.file.filePathURL
                    }
                    Spacer()
                    HStack {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "minus.circle")
                            }
                        }.onTapGesture {
                            print("Deleting folder")
                            do {
                                try FileManager.default.removeItem(at: self.file.filePathURL)
                            } catch {
                                print(error.localizedDescription)
                            }
                            self.settings.currentDir = self.settings.currentDir
                        }
                        Spacer()
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "pencil.circle")
                            }
                        }
                        .onTapGesture {
                            print("Renaming folder")
                            self.settings.fileToRename = self.file
                            self.showingRenameDirectoryAlert.toggle()
                        }
                    }.textFieldAlert(isShowing: self.$showingRenameDirectoryAlert, text: self.$alertText, title: "Alert!", callback: createRenameCB(currentFile: self.file))
                }
            :
                HStack(alignment: .bottom, spacing: 60.0) {
                    Button(action: { }) {
                        HStack {
                            Image(systemName: "doc")
                            Text(file.displayName)
                        }
                    }
                    .frame(width: 160, height: 15, alignment: .leading)
                    .onTapGesture {
                        print("Setting file")
                        self.settings.currentFile = self.file
                        self.setEditorView()
                    }
                    Spacer()
                    HStack {
                        Button(action: { }) {
                            HStack {
                                Image(systemName: "minus.circle")
                            }
                        }.onTapGesture {
                            print("Deleting file")
                            do {
                                try FileManager.default.removeItem(at: self.file.filePathURL)
                            } catch {
                                print(error.localizedDescription)
                            }
                            self.settings.currentDir = self.settings.currentDir
                        }
                        Spacer()
                        Button(action: { }) {
                            HStack {
                                Image(systemName: "pencil.circle")
                            }
                        }.onTapGesture {
                            print("Renaming file")
                            self.settings.fileToRename = self.file
                        }
                    }.textFieldAlert(isShowing: self.$showingRenameFileAlert, text: self.$alertText, title: "Alert!", callback: createRenameCB(currentFile: self.file))
                }
        
        }
    }
}

struct ListFilesView: SwiftUI.View {
        @State private var files: [FVFile] = []
        @ObservedObject var settings: UserSettings
        var setEditorView: () -> Void
        @State private var showNewDirectoryPopover = false
        @State private var showNewFilePopover = false
        @State private var showPopover = false
        @State var selection = Set<String>()
    
    var body: some SwiftUI.View {
        List(settings.files, id: \.self, selection: $selection) { file in
            FileOrDirectoryItemView(settings: self.settings, file: file, setEditorView: self.setEditorView)
        }
        .popover(
            isPresented: self.$showPopover,
            arrowEdge: .bottom
        ) {
            if (self.showNewFilePopover) {
                FilePopover(settings: self.settings).onDisappear {
                    self.showNewFilePopover.toggle()
                    self.showPopover = false
                }
            } else {
                DirectoryPopover(settings: self.settings).onDisappear {
                    self.showNewDirectoryPopover.toggle()
                    self.showPopover = false
                }
            }
        }
        
        .navigationBarItems(leading:
        HStack {
            Button(action: {
                self.showNewDirectoryPopover = true
                self.showPopover = true
            }) {
                Image(systemName: "folder.badge.plus")
            }
        },
        trailing: HStack {
            Button(action: {
                self.showNewFilePopover = true
                self.showPopover = true
            }) {
                Image(systemName: "plus.square")
            }
        })
    }
}

struct FilesView: SwiftUI.View {
    @ObservedObject var settings: UserSettings
    var setEditorView: () -> Void
    var body: some SwiftUI.View {
        NavigationView {
            ListFilesView(settings: self.settings, setEditorView: setEditorView).navigationBarTitle(Text("Files"), displayMode: .inline)
        }
        .onAppear {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            self.settings.currentDir = documentsDirectory
        }
    }
}
