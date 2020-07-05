//
//  EditorView.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/4/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI
import Sourceful


class EditorViewController: UIViewController, SyntaxTextViewDelegate {
    func lexerForSource(_ source: String) -> Lexer {
        return lexer
    }
    
    @IBOutlet var editorView: SyntaxTextView!
    let lexer = SwiftLexer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editorView = SyntaxTextView()
        editorView.theme = DefaultSourceCodeTheme()
        editorView.delegate = self
        
        self.view.addSubview(editorView)

        editorView.translatesAutoresizingMaskIntoConstraints = false
        editorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        editorView.topAnchor.constraint (equalTo: self.view.topAnchor).isActive = true
        editorView.widthAnchor.constraint (equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

struct EditorView: UIViewControllerRepresentable {
func makeUIViewController(context: Context) -> EditorViewController {
    let storyboard = UIStoryboard(name: "Editor", bundle: nil)

    let viewController = storyboard.instantiateViewController(identifier: "Editor", creator: { (coder) in
    let editorViewController = EditorViewController(coder: coder)
    return editorViewController
    }) as! EditorViewController
    
    return viewController
    }
    
    func updateUIViewController(_ uiViewController: EditorViewController, context: Context) {
        let e = uiViewController as EditorViewController
    }

}
