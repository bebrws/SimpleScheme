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

                    }) {
                        Text("Create File")
                    }
                }.padding(20)
            }
        }
    }
}


struct ListFilesView: SwiftUI.View {
        @State private var files: [FVFile] = []
        @ObservedObject var settings: UserSettings
        var setEditorView: () -> Void
//        @State var isEditing = false
        @State private var showNewDirectoryPopover = false
        @State private var showNewFilePopover = false
        @State private var showPopover = false
        @State var selection = Set<String>()
    
    var body: some SwiftUI.View {
        List(settings.files, id: \.self, selection: $selection) { file in
            file.isDirectory ?
                Button(action: {
                    self.settings.currentDir = file.filePathURL
                }) {
                    HStack {
                        Image(systemName: "folder")
                        Text(file.displayName)
                    }
                }
            :
                Button(action: {
                    self.settings.currentFile = file
                    self.setEditorView()
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text(file.displayName)
                    }
                }
            
        }
//        .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
        
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
//            Button(action: {
//                self.isEditing.toggle()
//            }) {
//                HStack {
//                    Text(isEditing ? "Done" : "Edit")
//                    Image(systemName: "pencil")
//                }
//            }
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
