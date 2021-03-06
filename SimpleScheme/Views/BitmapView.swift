//
//  OutputConsoleView.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/16/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI


//class BitmapViewController: UIViewController {
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

let PIXELS_WIDTH = 300
let PIXELS_HEIGHT = 300
var pixels = UnsafeMutablePointer<UInt8>.allocate(capacity: PIXELS_WIDTH*PIXELS_HEIGHT*4)
let pixelsSerialQueue = DispatchQueue(label: "pixels.serial.queue")

struct BitmapView: UIViewRepresentable {
    typealias UIViewType = UIImageView
    
//    var pixels: [PixelData]
    
    @EnvironmentObject var store: Store<SimpleSchemeState>
    
    func makeUIView(context: Context) -> UIImageView {
        let newImageView = UIImageView(frame: CGRect(x:0, y:0, width:300, height:300));
        newImageView.image = self.drawPixelArray(imageView: newImageView)
        
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
//            DispatchQueue.main.async {
//                newImageView.image =  nil
//                newImageView.image = self.drawPixelArray(imageView: newImageView)
//                newImageView.setNeedsDisplay()
//            }
//        }

        
        return newImageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        print("Update BitmapView")
//        DispatchQueue.main.async {
//            uiView.image =  nil
//            uiView.image = self.drawPixelArray(imageView: uiView)
//            uiView.setNeedsDisplay()
//        }
    }
    

    
    func drawPixelArray(imageView: UIImageView) -> UIImage {
        var imageRef = imageView.image?.cgImage
        
//        let oldWidth = UInt(imageRef?.width ?? 0)
//        let oldHeight = UInt(imageRef?.height ?? 0)

        let colorSpaceRef = CGColorSpaceCreateDeviceRGB() //color space info which we need to create our drawing env
        let context = CGContext(data: pixels, width: Int(PIXELS_WIDTH), height: Int(PIXELS_HEIGHT), bitsPerComponent: 8, bytesPerRow: Int(4 * PIXELS_WIDTH), space: colorSpaceRef, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) //our quartz2d drawing env
         //release the color space info
        
        if (imageRef != nil) {
            context?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: CGFloat(PIXELS_WIDTH), height: CGFloat(PIXELS_HEIGHT)))
        }
        
        imageRef = context?.makeImage() //create a CGIMageRef from our pixeldata
        //release the drawing env and pixel data

        let newUIImage = UIImage(cgImage: imageRef!)
        return newUIImage
    }

}
