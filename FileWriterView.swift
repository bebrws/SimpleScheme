//
//  FileWriterView.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/4/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI



struct FileWriterView: SwiftUI.View {
   @State private var filename: String = ""
   var body: some SwiftUI.View {
    VStack {
        TextField("Enter your name", text: $filename)
        Text("Open").onTapGesture {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            
            let url = paths[0].appendingPathComponent(self.filename + ".scheme")
            try! "etst".write(to: url, atomically: true, encoding: .utf8)
//            do {
//                try "test".write(to: url, atomically: true, encoding: .utf8)
//                let input = try String(contentsOf: url)
//                print(input)
//            } catch {
//                print(error.localizedDescription)
//            }
        }
    }
    }
}
