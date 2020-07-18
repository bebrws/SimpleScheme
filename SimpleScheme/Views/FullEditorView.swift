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
// TODO: Cleanup
var strCopy: String = ""
var pixelCallbackNotSet: Bool = true
let pipe = Pipe() // TODO: Move to a store?
let pipeErr = Pipe() // TODO: Move to a store?


var timeoutHasElapsed = true

struct FullEditorView: SwiftUI.View {
    @EnvironmentObject var store: Store<SimpleSchemeState>
    
    var setOutputConsoleView: () -> Void
    var body: some SwiftUI.View {
        VStack(alignment: .leading, spacing: 5.0) {
            HStack {
                Button(action: {
                if (timeoutHasElapsed) {
                    timeoutHasElapsed = false;
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        timeoutHasElapsed = true;
                    })
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
                        
                        if (pixelCallbackNotSet) {
                            pixelCallbackNotSet = false
                            setpixelcb({ (x: Int32, y: Int32, r: UInt8, g: UInt8, b: UInt8, a: UInt8) in
                                
                                // Clearing the screen due to out of bounds?
                                if ((x < 0 || x >= PIXELS_WIDTH) || (y < 0 || y >= PIXELS_HEIGHT)) {
                                    // Then its a clear screen request
                                    for y in 0..<Int(PIXELS_HEIGHT) {
                                       for x in 0..<Int(PIXELS_WIDTH) {
                                           let idx = (Int(PIXELS_WIDTH) * y + x) * 4
                                           //red
                                           pixels[idx] = 0
                                           //green
                                           pixels[idx+1] = 0
                                           // blue
                                           pixels[idx+2] = 0
                                           // Alpha channel:
                                           pixels[idx+3] = 0
                                       }
                                   }
                                // Or drawing a pixel?
                                } else {
                            
                                    let idx = (Int32(PIXELS_WIDTH) * y + x) * 4
                                            //red
                                    pixels[Int(idx)] = r
                                            //green
                                    pixels[Int(idx)+1] = g
                                            // blue
                                    pixels[Int(idx)+2] = b
                                            // Alpha channel:
                                    pixels[Int(idx)+3] = 255 // TODO: CHANGE THIS TO BE ALPHA
//                                    print("%d %d %d %d", r,g,b,a)
                                }
                            })
                        }
                        
                        self.store.state.currentFileContents.split(whereSeparator: \.isNewline).forEach({ aLine in
                            
                            chickenrun(String(aLine))
                        })
                        
                        // Then jump to the console view
                        self.setOutputConsoleView()
                    } else {
                        print("No file selected")
                    }
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
