//
//  FilesView.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/12/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI

struct DirectoryPopover: View {
    @EnvironmentObject var store: Store<SimpleSchemeState>
    
    var hideCallback: () -> Void
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
                        self.store.dispatch(action: SimpleSchemeActions.createDirectory(newName: self.newDirectoryName, hideCallback: self.hideCallback))
                        self.store.dispatch(action: SimpleSchemeActions.updateFileListings())
                    }) {
                        Text("Create Directory")
                    }
                }.padding(20)
            }
        }
    }
}


struct FilePopover: SwiftUI.View {
    @EnvironmentObject var store: Store<SimpleSchemeState>
    
    var hideCallback: () -> Void
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
                        self.store.dispatch(action: SimpleSchemeActions.createFile(newName: self.newFileName, hideCallback: self.hideCallback))
                        self.store.dispatch(action: SimpleSchemeActions.updateFileListings())
                    }) {
                        Text("Create File")
                    }
                }.padding(20)
            }
        }
    }
}

struct RenamingPopover: SwiftUI.View {
    @EnvironmentObject var store: Store<SimpleSchemeState>
    
    @State private var newName: String = ""
    
    var hideCallback: () -> Void
    var body: some SwiftUI.View {
        VStack {
            Text("File and Folder Reanming")
            HStack {
                VStack {
                    TextField("Enter the new name", text: self.$newName)
                }.padding(20)
                VStack {
                    Button(action: {
                        self.store.dispatch(action: SimpleSchemeActions.renameFileOrDirectory(newName: self.newName, hideCallback: self.hideCallback))
                        self.store.dispatch(action: SimpleSchemeActions.updateFileListings())
                    }) {
                        Text("Rename File")
                    }
                }.padding(20)
            }
        }
    }
}

struct FileOrDirectoryItemView: SwiftUI.View {
    @EnvironmentObject var store: Store<SimpleSchemeState>
    
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
                        self.store.dispatch(action: SimpleSchemeActions.setCurrentDirectory(directory: self.self.file.filePath))
                        self.store.dispatch(action: SimpleSchemeActions.updateFileListings())
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "minus.circle")
                        .onTapGesture {
                            print("Deleting folder")
                            self.store.dispatch(action: SimpleSchemeActions.deleteFileOrFolder(filePath: self.self.file.filePath))
                            self.store.dispatch(action: SimpleSchemeActions.updateFileListings())
                        }
                        Spacer()
                        Image(systemName: "pencil.circle")
                        .onTapGesture {
                            print("Renaming folder")
                            self.store.dispatch(action: SimpleSchemeActions.setFileToRename(file: self.file))
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
                        self.store.dispatch(action: SimpleSchemeActions.setCurrentFile(file: self.file))
                        self.setEditorView()
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "minus.circle")
                        .onTapGesture {
                            print("Deleting file")
                            self.store.dispatch(action: SimpleSchemeActions.deleteFileOrFolder(filePath: self.self.file.filePath))
                            self.store.dispatch(action: SimpleSchemeActions.updateFileListings())
                        }
                        Spacer()
                        Image(systemName: "pencil.circle")
                        .onTapGesture {
                            print("Renaming file")
                            self.store.state.fileToRename = self.file
                            self.showRenamingPopover.toggle()
                        }
                    }
                }
        
        }
        .popover(
            isPresented: self.$showRenamingPopover,
            arrowEdge: .bottom
        ) {
            RenamingPopover(hideCallback: { self.showRenamingPopover.toggle() })
        }
    }
}

struct ListFilesView: SwiftUI.View {
        @EnvironmentObject var store: Store<SimpleSchemeState>
    
        @State private var files: [FVFile] = []
        var setEditorView: () -> Void
        @State private var showNewDirectoryPopover = false
        @State private var showNewFilePopover = false
        @State private var showPopover = false
        @State var selection = Set<String>()
    
    var body: some SwiftUI.View {
        List(self.store.state.files, id: \.self, selection: $selection) { file in
            FileOrDirectoryItemView(file: file, setEditorView: self.setEditorView)
        }
        .popover(
            isPresented: self.$showPopover,
            arrowEdge: .bottom
        ) {
            if (self.showNewFilePopover) {
                FilePopover(hideCallback: {
                    self.showNewFilePopover.toggle()
                    self.showPopover = false
                })
            } else {
                DirectoryPopover(hideCallback: {
                    self.showNewDirectoryPopover.toggle()
                    self.showPopover = false
                })
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
    @EnvironmentObject var store: Store<SimpleSchemeState>
    
    var setEditorView: () -> Void
    var body: some SwiftUI.View {
        NavigationView {
            ListFilesView(setEditorView: setEditorView).navigationBarTitle(Text("Files"), displayMode: .inline)
        }
        .onAppear {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            self.store.dispatch(action: SimpleSchemeActions.setCurrentDirectory(directory: documentsDirectory))
            
        }
    }
}
