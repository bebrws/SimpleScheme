//
//  DocPickerView.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/4/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI
import MobileCoreServices


class DocPickerUIView: UIView {

}

class DocPickerViewController: UIViewController, UIDocumentPickerDelegate, UINavigationControllerDelegate  {
//    func didPickDocuments(documents: [Document]?) {
//        let docs=documents
//        if ((docs) != nil) {
//        print("got docs")
//        } else {
//            print("no docs")
//        }
//
//    }
    
//    var documentPicker: DocumentPicker!
    var dockPickerView: DocPickerUIView!
//    var button: UIButton!
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        dockPickerView = DocPickerUIView()
//        self.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100.0)
//        dockPickerView.backgroundColor = .red
        self.view.addSubview(dockPickerView)
//       documentPicker = DocumentPicker(presentationController: self, delegate: self)
 
//        dockPickerView.translatesAutoresizingMaskIntoConstraints = false
//        dockPickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        dockPickerView.topAnchor.constraint (equalTo: self.view.topAnchor).isActive = true
//        dockPickerView.widthAnchor.constraint (equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let docsTypes = ["public.text",
                                "com.apple.iwork.pages.pages",
                                "public.data",
                                "kUTTypeItem",
                                "kUTTypeContent",
                                "kUTTypeCompositeContent",
                                "kUTTypeData",
                                "public.database",
                                "public.calendar-event",
                                "public.message",
                                "public.presentation",
                                "public.contact",
                                "public.archive",
                                "public.disk-image",
                                "public.plain-text",
                                "public.utf8-plain-text",
                                "public.utf16-external-plain-​text",
                                "public.utf16-plain-text",
                                "com.apple.traditional-mac-​plain-text",
                                "public.rtf",
                                "com.apple.ink.inktext",
                                "public.html",
                                "public.xml",
                                "public.source-code",
                                "public.c-source",
                                "public.objective-c-source",
                                "public.c-plus-plus-source",
                                "public.objective-c-plus-​plus-source",
                                "public.c-header",
                                "public.c-plus-plus-header",
                                "com.sun.java-source",
                                "public.script",
                                "public.assembly-source",
                                "com.apple.rez-source",
                                "public.mig-source",
                                "com.apple.symbol-export",
                                "com.netscape.javascript-​source",
                                "public.shell-script",
                                "public.csh-script",
                                "public.perl-script",
                                "public.python-script",
                                "public.ruby-script",
                                "public.php-script",
                                "com.sun.java-web-start",
                                "com.apple.applescript.text",
                                "com.apple.applescript.​script",
                                "public.object-code",
                                "com.apple.mach-o-binary",
                                "com.apple.pef-binary",
                                "com.microsoft.windows-​executable",
                                "com.microsoft.windows-​dynamic-link-library",
                                "com.sun.java-class",
                                "com.sun.java-archive",
                                "com.apple.quartz-​composer-composition",
                                "org.gnu.gnu-tar-archive",
                                "public.tar-archive",
                                "org.gnu.gnu-zip-archive",
                                "org.gnu.gnu-zip-tar-archive",
                                "com.apple.binhex-archive",
                                "com.apple.macbinary-​archive",
                                "public.url",
                                "public.file-url",
                                "public.url-name",
                                "public.vcard",
                                "public.image",
                                "public.fax",
                                "public.jpeg",
                                "public.jpeg-2000",
                                "public.tiff",
                                "public.camera-raw-image",
                                "com.apple.pict",
                                "com.apple.macpaint-image",
                                "public.png",
                                "public.xbitmap-image",
                                "com.apple.quicktime-image",
                                "com.apple.icns",
                                "com.apple.txn.text-​multimedia-data",
                                "public.audiovisual-​content",
                                "public.movie",
                                "public.video",
                                "com.apple.quicktime-movie",
                                "public.avi",
                                "public.mpeg",
                                "public.mpeg-4",
                                "public.3gpp",
                                "public.3gpp2",
                                "public.audio",
                                "public.mp3",
                                "public.mpeg-4-audio",
                                "com.apple.protected-​mpeg-4-audio",
                                "public.ulaw-audio",
                                "public.aifc-audio",
                                "public.aiff-audio",
                                "com.apple.coreaudio-​format",
                                "public.directory",
                                "public.folder",
                                "public.volume",
                                "com.apple.package",
                                "com.apple.bundle",
                                "public.executable",
                                "com.apple.application",
                                "com.apple.application-​bundle",
                                "com.apple.application-file",
                                "com.apple.deprecated-​application-file",
                                "com.apple.plugin",
                                "com.apple.metadata-​importer",
                                "com.apple.dashboard-​widget",
                                "public.cpio-archive",
                                "com.pkware.zip-archive",
                                "com.apple.webarchive",
                                "com.apple.framework",
                                "com.apple.rtfd",
                                "com.apple.flat-rtfd",
                                "com.apple.resolvable",
                                "public.symlink",
                                "com.apple.mount-point",
                                "com.apple.alias-record",
                                "com.apple.alias-file",
                                "public.font",
                                "public.truetype-font",
                                "com.adobe.postscript-font",
                                "com.apple.truetype-​datafork-suitcase-font",
                                "public.opentype-font",
                                "public.truetype-ttf-font",
                                "public.truetype-collection-​font",
                                "com.apple.font-suitcase",
                                "com.adobe.postscript-lwfn​-font",
                                "com.adobe.postscript-pfb-​font",
                                "com.adobe.postscript.pfa-​font",
                                "com.apple.colorsync-profile",
                                "public.filename-extension",
                                "public.mime-type",
                                "com.apple.ostype",
                                "com.apple.nspboard-type",
                                "com.adobe.pdf",
                                "com.adobe.postscript",
                                "com.adobe.encapsulated-​postscript",
                                "com.adobe.photoshop-​image",
                                "com.adobe.illustrator.ai-​image",
                                "com.compuserve.gif",
                                "com.microsoft.bmp",
                                "com.microsoft.ico",
                                "com.microsoft.word.doc",
                                "com.microsoft.excel.xls",
                                "com.microsoft.powerpoint.​ppt",
                                "com.microsoft.waveform-​audio",
                                "com.microsoft.advanced-​systems-format",
                                "com.microsoft.windows-​media-wm",
                                "com.microsoft.windows-​media-wmv",
                                "com.microsoft.windows-​media-wmp",
                                "com.microsoft.windows-​media-wma",
                                "com.microsoft.advanced-​stream-redirector",
                                "com.microsoft.windows-​media-wmx",
                                "com.microsoft.windows-​media-wvx",
                                "com.microsoft.windows-​media-wax",
                                "com.apple.keynote.key",
                                "com.apple.keynote.kth",
                                "com.truevision.tga-image",
                                "com.sgi.sgi-image",
                                "com.ilm.openexr-image",
                                "com.kodak.flashpix.image",
                                "com.j2.jfx-fax",
                                "com.js.efx-fax",
                                "com.digidesign.sd2-audio",
                                "com.real.realmedia",
                                "com.real.realaudio",
                                "com.real.smil",
                                "com.allume.stuffit-archive",
                                "org.openxmlformats.wordprocessingml.document",
                                "com.microsoft.powerpoint.​ppt",
                                "org.openxmlformats.presentationml.presentation",
                                "com.microsoft.excel.xls",
                                "org.openxmlformats.spreadsheetml.sheet",
                               
          
        ]
        let importMenu = UIDocumentPickerViewController(documentTypes: docsTypes, in: .import )
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        importMenu.directoryURL = documentsDirectory
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet

        present(importMenu, animated: true)
//        documentPicker.present(from: dockPickerView)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        viewModel.attachDocuments(at: urls)
    }

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}

struct DocPickerView: UIViewControllerRepresentable {
func makeUIViewController(context: Context) -> DocPickerViewController {
//    let storyboard = UIStoryboard(name: "DockPicker", bundle: nil)
//    let viewController = storyboard.instantiateViewController(identifier: "DockPicker", creator: { (coder) in
//    let editorViewController = DocPickerViewController(coder: coder)
//    return editorViewController
//    }) as! DocPickerViewController
//
//
//    return DocPickerViewController()
    let vc = DocPickerViewController()
    vc.view.heightAnchor.constraint(equalToConstant: 20)
    return vc
    }
    
    func updateUIViewController(_ uiViewController: DocPickerViewController, context: Context) {
        let e = uiViewController as DocPickerViewController
    }
    


}

