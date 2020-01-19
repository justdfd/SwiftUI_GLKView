//
//  GLKView.swift
//  justDFD
//
//  Created by Dave Dombrowski on 12/28/18.
//  Copyright © 2018 justDFD. All rights reserved.
//

import SwiftUI
import UIKit
import GLKit

struct GLKViewerVC: UIViewControllerRepresentable {
    @EnvironmentObject var model: Model
    let glkViewVC = ImageViewVC()
    
    func makeUIViewController(context: Context) -> ImageViewVC {
        return glkViewVC
    }
    func updateUIViewController(_ uiViewController: ImageViewVC, context: Context) {
        glkViewVC.model = model
    }
}
class ImageViewVC: UIViewController {
    var model: Model!
    var imageView = ImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = imageView
        NotificationCenter.default.addObserver(self, selector: #selector(updateImage), name: .updateImage, object: nil)
    }
    override func viewDidLayoutSubviews() {
        imageView.setNeedsDisplay()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .light {
            imageView.clearColor = UIColor.white
        } else {
            imageView.clearColor = UIColor.black
        }
    }
    @objc func updateImage() {
        imageView.image = model.ciFinal
        imageView.setNeedsDisplay()
    }
}
class ImageView: GLKView {
    
    var renderContext: CIContext
    var myClearColor:UIColor!
    var rgb:(Int?,Int?,Int?)!
    
    public var image: CIImage! {
        didSet {
            setNeedsDisplay()
        }
    }
    public var clearColor: UIColor! {
        didSet {
            myClearColor = clearColor
        }
    }
    
    public init() {
        let eaglContext = EAGLContext(api: .openGLES2)
        renderContext = CIContext(eaglContext: eaglContext!)
        super.init(frame: CGRect.zero)
        context = eaglContext!
    }
    
    override public init(frame: CGRect, context: EAGLContext) {
        renderContext = CIContext(eaglContext: context)
        super.init(frame: frame, context: context)
        enableSetNeedsDisplay = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        let eaglContext = EAGLContext(api: .openGLES2)
        renderContext = CIContext(eaglContext: eaglContext!)
        super.init(coder: aDecoder)
        context = eaglContext!
    }
    
    override public func draw(_ rect: CGRect) {
        if let image = image {
            let imageSize = image.extent.size
            var drawFrame = CGRect(x: 0, y: 0, width: CGFloat(drawableWidth), height: CGFloat(drawableHeight))
            let imageAR = imageSize.width / imageSize.height
            let viewAR = drawFrame.width / drawFrame.height
            if imageAR > viewAR {
                drawFrame.origin.y += (drawFrame.height - drawFrame.width / imageAR) / 2.0
                drawFrame.size.height = drawFrame.width / imageAR
            } else {
                drawFrame.origin.x += (drawFrame.width - drawFrame.height * imageAR) / 2.0
                drawFrame.size.width = drawFrame.height * imageAR
            }
            rgb = (0,0,0)
            rgb = myClearColor.rgb()
            glClearColor(Float(rgb.0!)/256.0, Float(rgb.1!)/256.0, Float(rgb.2!)/256.0, 0.0);
            glClear(0x00004000)
            // set the blend mode to "source over" so that CI will use that
            glEnable(0x0BE2);
            glBlendFunc(1, 0x0303);
            renderContext.draw(image, in: drawFrame, from: image.extent)
        }
    }
    
}
class test {
    class ImageViewVC: UIViewController {
        var model: Model!
        var imageView = ImageView()

        override func viewDidLoad() {
            super.viewDidLoad()
            imageView.layer.borderWidth = 1
            view = imageView
            NotificationCenter.default.addObserver(self, selector: #selector(updateImage), name: .updateImage, object: nil)
        }
        override func viewDidLayoutSubviews() {
            imageView.setNeedsDisplay()
        }
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if traitCollection.userInterfaceStyle == .light {
                imageView.clearColor = UIColor.white
            } else {
                imageView.clearColor = UIColor.black
            }
        }
        @objc func updateImage() {
            imageView.image = model.ciFinal
            imageView.setNeedsDisplay()
        }
    }
}
extension UIColor {
    public func rgb() -> (Int?, Int?, Int?) {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            return (iRed, iGreen, iBlue)
        } else {
            // Could not extract RGBA components:
            return (nil,nil,nil)
        }
    }
}
