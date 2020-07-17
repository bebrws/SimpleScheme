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


class EditorViewController: UIViewController, SyntaxTextViewDelegate, UITextViewDelegate {
    var store: Store<SimpleSchemeState>?
    let fileBeingEdited:FVFile? = nil
    
    func lexerForSource(_ source: String) -> Lexer {
        return lexer
    }
    
    @IBOutlet var editorView: SyntaxTextView!
    let lexer = SwiftLexer()
    
    func didChangeText(_ syntaxTextView: SyntaxTextView) {
        if (store!.state.currentFile == nil) {
            let alert = UIAlertController(title: "No File Selected", message: "Please use the files tab to select a file to edit.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        if (store!.state.currentFile != nil) {
            store!.state.currentFileContents = editorView.text
        }
    }
    
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
    
    func update(store: Store<SimpleSchemeState>) {
        if (self.fileBeingEdited == store.state.currentFile) {
            // No change
        } else if (store.state.currentFile != nil) {
            // File changed so re load data
            let fileDataContents = try! Data(contentsOf: store.state.currentFile!.filePath as URL)
            let fileContentsString = String(data: fileDataContents, encoding: .utf8)
            self.editorView.text = fileContentsString!
                        
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    required init?(coder: NSCoder, store: Store<SimpleSchemeState>) {
        self.store = store
        super.init(coder: coder)
    }
}

struct EditorView: UIViewControllerRepresentable {
    @EnvironmentObject var store: Store<SimpleSchemeState>
    
func makeUIViewController(context: Context) -> EditorViewController {
    let storyboard = UIStoryboard(name: "Editor", bundle: nil)

    let viewController = storyboard.instantiateViewController(identifier: "Editor", creator: { (coder) in
        let editorViewController = EditorViewController(coder: coder, store: self.store)
    return editorViewController
    }) as! EditorViewController
    
    return viewController
    }
    
    func updateUIViewController(_ uiViewController: EditorViewController, context: Context) {
        let e = uiViewController as EditorViewController
        e.update(store: self.store)
    }

}
