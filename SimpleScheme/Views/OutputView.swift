//
//  OutputView.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/10/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI

//class OutputViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        self.view.addSubview(OutputView)
////
////        OutputView.translatesAutoresizingMaskIntoConstraints = false
////        OutputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
////        OutputView.topAnchor.constraint (equalTo: self.view.topAnchor).isActive = true
////        OutputView.widthAnchor.constraint (equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//
//    func updateSettings(settings: UserSettings) {
//        // Set the console output here
//        // Of if pixels are passed in state draw new pixels here
//        // Ill probably expose methods for drawing
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//}

struct TextConsoleView: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @EnvironmentObject var store: Store<SimpleSchemeState>
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isSelectable = false
        textView.isEditable = false
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let textView = uiView as UITextView
        textView.text = self.store.state.consoleOutput
    }

}

//var pixels: [PixelData] = [PixelData]()


struct OutputView: SwiftUI.View {
    @EnvironmentObject var store: Store<SimpleSchemeState>
    
    var body: some SwiftUI.View {
        VStack {
            Text("Bitmap Output:")
            BitmapView()
            .padding()
            .border(Color.black)
            Text("Text Output:")
            TextConsoleView()
            .padding()
            .border(Color.purple)
        }
        .onAppear {
            for y in 0..<Int(PIXELS_HEIGHT) {
                for x in 0..<Int(PIXELS_WIDTH) {
                    let idx = (Int(PIXELS_WIDTH) * y + x) * 4
                    //red
                    pixels[idx] = 10
                    //green
                    pixels[idx+1] = 100
                    // blue
                    pixels[idx+2] = 100
                    // Alpha channel:
                    pixels[idx+3] = 255
                }
            }
        }
    }
}
