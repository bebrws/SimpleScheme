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

class UserSettings: ObservableObject {
    @Published var currentFileContents: String = ""
    @Published var consoleOutput: String = ""
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


struct TempOutputView: SwiftUI.View {
    @State var settings:UserSettings
    
    // 2 sections on top of each other
    // the top being where pixels can be rendered
    // the bottom being console output
    //
    // Both of which are custom components
    var body: some SwiftUI.View {
        Text("Output")
    }
}


struct FullEditorView: SwiftUI.View {
    @State var settings:UserSettings
    var body: some SwiftUI.View {
        VStack(alignment: .leading, spacing: 5.0) {
            HStack {
                Button(action: {
                    // SAve the file
                    do {
                        try self.settings.currentFileContents.write(to: self.settings.currentFile!.filePathURL, atomically: true, encoding: .utf8)
                    } catch {
                        print("Error saving file")
                        print(error.localizedDescription)
                    }
                    // Then begin execution and jump to the console view
                    // Before execution pip stdout
                    // Start execution
                }) {
                    HStack {
                        Image(systemName: "play")
                        Text("Run")
                    }
                }
            }.padding(.leading, 20.0)
            EditorView(settings: settings)
        }
    }
}


struct ContentView: SwiftUI.View {
    @State private var selection = 0
    @State private var settings:UserSettings = UserSettings()
    @State private var selectedTab = 1
    var body: some SwiftUI.View {
        TabView(selection: $selectedTab) {
            FullEditorView(settings: settings).tabItem {
                Image(systemName: "list.dash")
                Text("Editor" + ((settings.currentFile != nil) ? (" - " + settings.currentFile!.displayName) : ""))
            }.tag(0)
            OutputConsoleView(settings: settings).tabItem {
                Image(systemName: "list.dash")
                Text("Output")
            }.tag(1)
            FilesView(settings: settings, setEditorView: { self.selectedTab = 0 }).tabItem {
                Image(systemName: "list.dash")
                Text("Files")
            }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ContentView()
    }
}
