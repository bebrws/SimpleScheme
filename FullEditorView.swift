//
//  FullEditorView.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/12/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


struct FullEditorView: SwiftUI.View {
    @State var settings:UserSettings
    var setOutputConsoleView: () -> Void
    var body: some SwiftUI.View {
        VStack(alignment: .leading, spacing: 5.0) {
            HStack {
                Button(action: {
                    if (self.settings.currentFile != nil) {
                        // Save the file
                        do {
                            try self.settings.currentFileContents.write(to: self.settings.currentFile!.filePathURL, atomically: true, encoding: .utf8)
                        } catch {
                            print("Error saving file")
                            print(error.localizedDescription)
                        }
                        
                        // Before execution pipe stdout
                        //    Clear the pre existing console output
                        self.settings.consoleOutput = ""
                        
                        if (self.settings.pipe == nil) {
                            self.settings.pipe = Pipe()
                            setvbuf(stdout, nil, _IONBF, 0)
                            dup2(self.settings.pipe!.fileHandleForWriting.fileDescriptor,
                                STDOUT_FILENO)
                            self.settings.pipe!.fileHandleForReading.readabilityHandler = { handle in
                                let data = handle.availableData
                                let str = String(data: data, encoding: .ascii) ?? "<Non-ascii data of size\(data.count)>\n"
                                DispatchQueue.main.async {
                                    self.settings.consoleOutput += str
                                }
                            }
                        }
                        
                        // Execute the scheme script
                        self.settings.currentFileContents.withCString { cstr in
                            scheme(cstr)
                        }
                        
                        // Then jump to the console view
                        self.setOutputConsoleView()
                    } else {
                        print("No file selected")
                    }
                }) {
                    HStack {
                        Image(systemName: "play")
                        Text("Save & Run")
                    }
                }
            }.padding(.leading, 20.0)
            EditorView(settings: settings)
        }
    }
}
