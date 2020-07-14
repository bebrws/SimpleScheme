//
//  FVFileType.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/12/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI

public enum FVFileType: String {
    case Default   = "file"
    case Directory = "directory"
    case PLIST     = "plist"
    case PNG       = "png"
    case ZIP       = "zip"
    case GIF       = "gif"
    case JPG       = "jpg"
    case JSON      = "json"
    case PDF       = "pdf"
    
    public func image() -> UIImage? {
        
//        var fileName = String()
//        switch self {
//        case Directory: fileName = "folder@2x.png"
//        case JPG, PNG, GIF: fileName = "image@2x.png"
//        case PDF: fileName = "pdf@2x.png"
//        case ZIP: fileName = "zip@2x.png"
//        default: fileName = "file@2x.png"
//        }
//        let file = UIImage(named: fileName, inBundle: bundle, compatibleWithTraitCollection: nil)
//        return file
        return UIImage()
    }
}
