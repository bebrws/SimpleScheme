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

struct RenamingPopover: SwiftUI.View {
    @ObservedObject var settings: UserSettings
    @State private var newFileName: String = ""
    var hideCallback: () -> Void
    var body: some SwiftUI.View {
        VStack {
            Text("File and Folder Reanming")
            HStack {
                VStack {
                    TextField("Enter the new name", text: self.$newFileName)
                }.padding(20)
                VStack {
                    Button(action: {
                        var currentPath = self.settings.fileToRename!.filePathURL.absoluteString
                        currentPath = currentPath.replacingOccurrences(of: "file://", with: "")
                        var newPath = self.settings.fileToRename!.filePathURL.absoluteString
                        newPath = newPath.replacingOccurrences(of: "file://", with: "")
                        newPath = String(newPath[..<newPath.lastIndex(of: "/")!])
                        newPath += "/" + self.newFileName

                        print("Renaming file/folder from:")
                        print(currentPath)
                        print("to:")
                        print(newPath)

                        do {
                            try FileManager.default.moveItem(atPath: currentPath, toPath: newPath)
                        } catch {
                            print(error.localizedDescription)
                        }
                        self.settings.currentDir = self.settings.currentDir
                        if (self.settings.currentFile?.filePathURL.absoluteString.contains(self.settings.fileToRename!.filePathURL.absoluteString))! {
                            self.settings.currentFile = nil
                        }
                        self.hideCallback()
                    }) {
                        Text("Rename File")
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
    @State private var showRenamingPopover: Bool = false
    @State private var alertText: String = ""
    
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
                    .frame(width: 150, height: 15, alignment: .leading)
                    .onTapGesture {
                        print("Selected folder")
                        self.settings.currentDir = self.file.filePathURL
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "minus.circle")
                        .onTapGesture {
                            print("Deleting folder")
                            do {
                                try FileManager.default.removeItem(at: self.file.filePathURL)
                            } catch {
                                print(error.localizedDescription)
                            }
                            self.settings.currentDir = self.settings.currentDir
                            self.settings.currentFile = nil
                        }
                        Spacer()
                        Image(systemName: "pencil.circle")
                        .onTapGesture {
                            print("Renaming folder")
                            self.settings.fileToRename = self.file
                            self.showRenamingPopover.toggle()
                        }
                    }
                }
            :
                HStack(alignment: .bottom, spacing: 60.0) {
                    Button(action: { }) {
                        HStack {
                            Image(systemName: "doc")
                            Text(file.displayName)
                        }
                    }
                    .frame(width: 150, height: 15, alignment: .leading)
                    .onTapGesture {
                        print("Setting file")
                        self.settings.currentFile = self.file
                        self.setEditorView()
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "minus.circle")
                        .onTapGesture {
                            print("Deleting file")
                            do {
                                try FileManager.default.removeItem(at: self.file.filePathURL)
                            } catch {
                                print(error.localizedDescription)
                            }
                            self.settings.currentDir = self.settings.currentDir
                            self.settings.currentFile = nil
                        }
                        Spacer()
                        Image(systemName: "pencil.circle")
                        .onTapGesture {
                            print("Renaming file")
                            self.settings.fileToRename = self.file
                            self.showRenamingPopover.toggle()
                        }
                    }
                }
        
        }
        .popover(
            isPresented: self.$showRenamingPopover,
            arrowEdge: .bottom
        ) {
            RenamingPopover(settings: self.settings, hideCallback: { self.showRenamingPopover.toggle() })
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
