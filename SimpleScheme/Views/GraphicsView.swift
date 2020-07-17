//
//  OutputView.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/10/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI

struct GraphicsView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    @EnvironmentObject var store: Store<SimpleSchemeState>
    
    func makeUIView(context: Context) -> UIView {
        let mainView = UIView()
        UIGraphicsBeginImageContext(mainView.frame.size)
        
        return mainView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        let textView = uiView as UIView
        // Read from settings and draw pixels?
    }

}
