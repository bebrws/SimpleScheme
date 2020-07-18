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

var imageRef: CGImage? = nil

struct OutputView: SwiftUI.View {
    @EnvironmentObject var store: Store<SimpleSchemeState>
    @State var image: UIImage = UIImage()
    
    var body: some SwiftUI.View {
        VStack {
            Text("Bitmap Output:")
            // BitmapView()
            Image(uiImage: self.image)
            .padding()
            .border(Color.black)
            Text("Text Output:")
            TextConsoleView()
            .padding()
            .border(Color.purple)
        }
        .onAppear {

            
//            for y in 0..<Int(PIXELS_HEIGHT) {
//                for x in 0..<Int(PIXELS_WIDTH) {
//                    let idx = (Int(PIXELS_WIDTH) * y + x) * 4
//                    //red
//                    pixels[idx] = 10
//                    //green
//                    pixels[idx+1] = 100
//                    // blue
//                    pixels[idx+2] = 100
//                    // Alpha channel:
//                    pixels[idx+3] = 120
//                }
//            }
            
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: PIXELS_WIDTH, height: PIXELS_HEIGHT))
            let img = renderer.image(actions: { ctx in
                  
                  let re = CGRect(x:0, y:0, width: CGFloat(PIXELS_WIDTH), height: CGFloat(PIXELS_HEIGHT))
                  ctx.currentImage.draw(in: re, blendMode: CGBlendMode.destinationAtop, alpha: 0.5)
                  
                  let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
                  
                  let context = CGContext(data: pixels, width: Int(PIXELS_WIDTH), height: Int(PIXELS_HEIGHT), bitsPerComponent: 8, bytesPerRow: Int(4 * PIXELS_WIDTH), space: colorSpaceRef, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
                  
                  ctx.cgContext.setStrokeColor( UIColor.black.cgColor)
                  ctx.cgContext.setFillColor( UIColor.black.cgColor)
                  context?.draw(ctx.currentImage.cgImage!, in:re)
                  
                  imageRef = context?.makeImage()
                  ctx.cgContext.draw(imageRef!, in: re)
                  
                  
                  ctx.cgContext.setStrokeColor( UIColor.black.cgColor)
                  ctx.cgContext.addRect(CGRect(x: 10, y: 10, width: 20, height: 30))
                  imageRef = context?.makeImage()
                  ctx.cgContext.draw(imageRef!, in: re)
                  // ctx.currentImage.cgImage = imageRef
                  
              })
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                DispatchQueue.main.async {
                    
                    let renderer = UIGraphicsImageRenderer(size: CGSize(width: PIXELS_WIDTH, height: PIXELS_HEIGHT))
                    
                    
                    let img = renderer.image(actions: { ctx in
                        
                        let re = CGRect(x:0, y:0, width: CGFloat(PIXELS_WIDTH), height: CGFloat(PIXELS_HEIGHT))
                        ctx.currentImage.draw(in: re, blendMode: CGBlendMode.destinationAtop, alpha: 0.5)
                        
                        let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
                        
                        let context = CGContext(data: pixels, width: Int(PIXELS_WIDTH), height: Int(PIXELS_HEIGHT), bitsPerComponent: 8, bytesPerRow: Int(4 * PIXELS_WIDTH), space: colorSpaceRef, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
                        
                        ctx.cgContext.setStrokeColor( UIColor.black.cgColor)
                        ctx.cgContext.setFillColor( UIColor.black.cgColor)
                        context?.draw(ctx.currentImage.cgImage!, in:re)
                        
                        imageRef = context?.makeImage()
                        ctx.cgContext.draw(imageRef!, in: re)
                        
                        
                        ctx.cgContext.setStrokeColor( UIColor.black.cgColor)
                        ctx.cgContext.addRect(CGRect(x: 10, y: 10, width: 20, height: 30))
                        imageRef = context?.makeImage()
                        ctx.cgContext.draw(imageRef!, in: re)
                        // ctx.currentImage.cgImage = imageRef
                        
                    })
                    
                    self.image = img
                    
//                    imageRef = self.image.cgImage
//
//                    let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
//                    let context = CGContext(data: pixels, width: Int(PIXELS_WIDTH), height: Int(PIXELS_HEIGHT), bitsPerComponent: 8, bytesPerRow: Int(4 * PIXELS_WIDTH), space: colorSpaceRef, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) //our quartz2d drawing env
//
//                    if (imageRef != nil) {
//                        context?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: CGFloat(PIXELS_WIDTH), height: CGFloat(PIXELS_HEIGHT)))
//                    }
//
//                    imageRef = context?.makeImage()
//                    var temp = imageRef?.copy()
////                    self.image =  nil
//                    self.image = UIImage(cgImage: temp!)
////                    self.image.renderingMode =  UIImage.RenderingMode.alwaysOriginal
                    
                    
                    
//                    newImageView.image =  nil
//                    newImageView.image = self.drawPixelArray(imageView: newImageView)
//                    newImageView.setNeedsDisplay()
                }
            }
        }
    }
}
