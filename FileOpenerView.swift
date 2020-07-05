//
//  FileOpenerView.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/4/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI


struct FileOpenerView: SwiftUI.View {
    @State var flag = false
    var body: some SwiftUI.View {
        VStack {
            Text("Flag").onTapGesture {
                self.flag.toggle()
            }
            Text("Run").onTapGesture {
                """
                 (displayln 23)
                 23
                 """.withCString {
                let result = scheme($0)
                let string = String(cString: result!)
                print("result:")
                print(string)
                }
            }
            if flag {
            VStack {
                DocPickerView().onDisappear {
                    self.flag.toggle()
                }
            }
            }
        }
    }
}
