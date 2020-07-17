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


// WARNING - Global:

let pipe = Pipe() // TODO: Move to a store?
let pipeErr = Pipe() // TODO: Move to a store?


struct FullEditorView: SwiftUI.View {
    @EnvironmentObject var store: Store<SimpleSchemeState>
    
    var setOutputConsoleView: () -> Void
    var body: some SwiftUI.View {
        VStack(alignment: .leading, spacing: 5.0) {
            HStack {
                Button(action: {
                    if (self.store.state.currentFile != nil) {
                        // Save the file
                        do {
                            try self.store.state.currentFileContents.write(to: self.store.state.currentFile!.filePath, atomically: true, encoding: .utf8)
                        } catch {
                            print("Error saving file")
                            print(error.localizedDescription)
                        }
                        
                        // Before execution pipe stdout
                        //    Clear the pre existing console output
                        self.store.state.consoleOutput = ""
                        
                        if (!self.store.state.isPipeCreated) {
                            setvbuf(stdout, nil, _IONBF, 0)
                            dup2(pipe.fileHandleForWriting.fileDescriptor,
                                STDOUT_FILENO)
                            pipe.fileHandleForReading.readabilityHandler = { handle in
                                let data = handle.availableData
                                let str = String(data: data, encoding: .ascii) ?? "<Non-ascii data of size\(data.count)>\n"
                                DispatchQueue.main.async {
                                    self.store.state.consoleOutput += str
                                }
                            }
                            
                            setvbuf(stderr, nil, _IONBF, 0)
                            dup2(pipeErr.fileHandleForWriting.fileDescriptor,
                                STDERR_FILENO)
                            pipeErr.fileHandleForReading.readabilityHandler = { handle in
                                let data = handle.availableData
                                let str = String(data: data, encoding: .ascii) ?? "<Non-ascii data of size\(data.count)>\n"
                                DispatchQueue.main.async {
                                    self.store.state.consoleOutput += str
                                }
                            }
                        }
                        
                        // Execute the scheme script
                        var result = UnsafeMutablePointer<Int>.allocate(capacity: 1)
                        
                        self.store.state.currentFileContents.withCString { cstr in
//                            var pri = Optional(UnsafePointer<Int8>(pixels))
//                            DispatchQueue.main.async {
//                                scheme(cstr, pixels)
                                // CHICKEN_eval_string(char *str, C_word *result)
                            setpixels(pixels)
                            chickenrun(cstr)
                            
//                            }
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
            EditorView()
        }
    }
}
