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


struct ContentView: SwiftUI.View {
    @EnvironmentObject var store: Store<SimpleSchemeState>
    
    @State private var selection = 0
    @State private var selectedTab = 2
    var body: some SwiftUI.View {
        TabView(selection: $selectedTab) {
            FullEditorView(setOutputConsoleView: { self.selectedTab = 1 }).tabItem {
                Image(systemName: "keyboard")
                Text("Editor" + ((self.store.state.currentFile != nil) ? (" - " + self.store.state.currentFile!.displayName) : ""))
            }.tag(0)
            OutputConsoleView().tabItem {
                Image(systemName: "desktopcomputer")
                Text("Output")
            }.tag(1)
            FilesView(setEditorView: { self.selectedTab = 0 }).tabItem {
                Image(systemName: "list.dash")
                Text("Files")
            }.tag(2)
            HelpView().tabItem {
                Image(systemName: "questionmark")
                Text("Help")
            }.tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ContentView()
    }
}
