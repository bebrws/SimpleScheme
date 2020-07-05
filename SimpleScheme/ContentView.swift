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






struct ContentView: SwiftUI.View {
    @State private var selection = 0
 
    var body: some SwiftUI.View {
        TabView {
            EditorView().tabItem {
                Image(systemName: "list.dash")
                Text("Editor")
            }
      
            FileOpenerView().tabItem {
                Image(systemName: "list.dash")
                Text("DockPicker")
            }
            FileWriterView().tabItem {
                Image(systemName: "list.dash")
                Text("Fopen")
            }
        }
    }
//    var body: some View {
//        TabView(selection: $selection){
//            Text("First View")
//                .font(.title)
//                .tabItem {
//                    VStack {
//                        Image("first")
//                        Text("First")
//                    }
//                }
//                .tag(0)
//            Text("Second View")
//                .font(.title)
//                .tabItem {
//                    VStack {
//                        Image("second")
//                        Text("Second")
//                    }
//                }
//                .tag(1)
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ContentView()
    }
}
