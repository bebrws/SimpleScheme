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
    
    let fileBeingEdited:FVFile? = nil
    
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
    
    func updateSettings(settings: UserSettings) {
        if (self.fileBeingEdited == settings.currentFile) {
            // No change
        } else {
            // File changed so re load data
            let fileDataContents = try! Data(contentsOf: settings.currentFile!.filePath as URL)
            let fileContentsString = String(data: fileDataContents, encoding: .utf8)
            self.editorView.text = fileContentsString!
                        
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init?(coder: NSCoder, settings: UserSettings) {
        self.init(coder: coder)
    }
}

struct EditorView: UIViewControllerRepresentable {
    @ObservedObject var settings: UserSettings
    
func makeUIViewController(context: Context) -> EditorViewController {
    let storyboard = UIStoryboard(name: "Editor", bundle: nil)

    let viewController = storyboard.instantiateViewController(identifier: "Editor", creator: { (coder) in
        let editorViewController = EditorViewController(coder: coder, settings: self.settings)
    return editorViewController
    }) as! EditorViewController
    
    return viewController
    }
    
    func updateUIViewController(_ uiViewController: EditorViewController, context: Context) {
        let e = uiViewController as EditorViewController
        e.updateSettings(settings: settings)
    }

}
