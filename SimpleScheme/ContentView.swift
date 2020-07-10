//
//  ContentView.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/4/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import SwiftUI
import MobileCoreServices
import Sourceful
import Combine

/// FBFile represents a file in FileBrowser
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

public enum FVFileType: String {
    case Default   = "file"
    case Directory = "directory"
    case PLIST     = "plist"
    case PNG       = "png"
    case ZIP       = "zip"
    case GIF       = "gif"
    case JPG       = "jpg"
    case JSON      = "json"
    case PDF       = "pdf"
    
    public func image() -> UIImage? {
        
//        var fileName = String()
//        switch self {
//        case Directory: fileName = "folder@2x.png"
//        case JPG, PNG, GIF: fileName = "image@2x.png"
//        case PDF: fileName = "pdf@2x.png"
//        case ZIP: fileName = "zip@2x.png"
//        default: fileName = "file@2x.png"
//        }
//        let file = UIImage(named: fileName, inBundle: bundle, compatibleWithTraitCollection: nil)
//        return file
        return UIImage()
    }
}


struct ListFilesView: SwiftUI.View {
        @State private var files: [FVFile] = []
        @ObservedObject var settings: UserSettings
        var setEditorView: () -> Void
        @State var isEditing = false
        @State private var showNewDirectorySheet = false
        @State private var showNewFileSheet = false
        @State private var newDirectoryName: String = ""
        @State private var newFileName: String = ""
        @State var selection = Set<String>()
    
    var body: some SwiftUI.View {
        VStack {
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
                        self.settings.openedFiles = [file]
                        self.setEditorView()
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text(file.displayName)
                        }
                    }
                
            }
            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
        }
        .popover(
            isPresented: self.$showNewDirectorySheet,
            arrowEdge: .bottom
        ) {
            VStack {
                TextField("Enter the directory name", text: self.$newDirectoryName)
                Button(action: {
                    let newDirFullPath = self.settings.currentDir.appendingPathComponent(self.newDirectoryName)
                    var newDirString = newDirFullPath.absoluteString
                    newDirString = newDirString.replacingOccurrences(of: "file://", with: "")
                        
                    let dataPath = newDirFullPath
                    if !FileManager.default.fileExists(atPath: newDirString) {
                        do {
                            try FileManager.default.createDirectory(atPath: newDirString, withIntermediateDirectories: true, attributes: nil)
                        } catch {
                            print(error.localizedDescription);
                        }
                    }
                    
                }) {
                    Text("Create Directory")
                }
            }
            
        }
        .popover(
            isPresented: self.$showNewFileSheet,
            arrowEdge: .bottom
        ) {
            VStack {
                TextField("Enter the file name", text: self.$newFileName)
                Button(action: {
                    let newFileFullPath = self.settings.currentDir.appendingPathComponent(self.newFileName)
                    var fileString = newFileFullPath.absoluteString
                    fileString = fileString.replacingOccurrences(of: "file://", with: "")
                    if !FileManager.default.fileExists(atPath: fileString) {
                        do {
                            try FileManager.default.createFile(atPath: fileString, contents: "".data(using: .utf8), attributes: nil)
                        } catch {
                            print(error.localizedDescription);
                        }
                    }

                }) {
                    Text("Create File")
                }
            }

        }
        .navigationBarItems(leading:
        HStack {
                Button(action: {
                    self.showNewDirectorySheet = true
            }) {
                Image(systemName: "folder.badge.plus")
            }
        },
        trailing: HStack {
                Button(action: {
                    self.showNewFileSheet = true
            }) {
                Image(systemName: "plus.square")
            }
            Button(action: {
                self.isEditing.toggle()
            }) {
                HStack {
                    Text(isEditing ? "Done" : "Edit")
                    Image(systemName: "pencil")
                }
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

class UserSettings: ObservableObject {
    @Published var currentFile: FVFile? = nil
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
    @Published var openedFiles = [FVFile]() {
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


struct ContentView: SwiftUI.View {
    @State private var selection = 0
    @State private var settings:UserSettings = UserSettings()
    @State private var selectedTab = 1
    var body: some SwiftUI.View {
        TabView(selection: $selectedTab) {
            EditorView(settings: settings).tabItem {
                Image(systemName: "list.dash")
                Text("Editor" + ((settings.currentFile != nil) ? (" - " + settings.currentFile!.displayName) : ""))
            }.tag(0)
            FilesView(settings: settings, setEditorView: { self.selectedTab = 0 }).tabItem {
                Image(systemName: "list.dash")
                Text("Files")
            }.tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ContentView()
    }
}
