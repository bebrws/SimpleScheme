//
//  TextView.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/12/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import UIKit
import Combine
import SwiftUI

struct TextView: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
//        textView.isSelectable = false
        textView.isEditable = false
        textView.text = self.text
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let textView = uiView as UITextView
    }

}
