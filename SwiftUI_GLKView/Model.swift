//
//  Model.swift
//  Darkroom
//
//  Created by Dave Dombrowski on 8/18/19.
//  Copyright © 2019 justDFD. All rights reserved.
//

import SwiftUI
import Combine

extension Notification.Name {
    static let updateImage = Notification.Name("UpdateImage")
}
class Model : ObservableObject {
    var objectWillChange = PassthroughSubject<Void, Never>()

    var uiOriginal:UIImage?
    var ciInput:CIImage?
    var ciFinal:CIImage?
    
    init() {
        uiOriginal = UIImage(named: "vermont.jpg")
        uiOriginal = uiOriginal!.resizeToBoundingSquare(640)
        ciInput = CIImage(image: uiOriginal!)?.rotateImage()
        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(ciInput, forKey: "inputImage")
        ciFinal = filter?.outputImage
    }
}
extension UIImage {
    public func resizeToBoundingSquare(_ boundingSquareSideLength : CGFloat) -> UIImage {
        let imgScale = self.size.width > self.size.height ? boundingSquareSideLength / self.size.width : boundingSquareSideLength / self.size.height
        let newWidth = self.size.width * imgScale
        let newHeight = self.size.height * imgScale
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return resizedImage!
    }
}
extension CIImage {
    public func rotateImage() -> CIImage {
        let image = UIImage(ciImage: self)
        if (image.imageOrientation == UIImage.Orientation.right) {
            return self.oriented(forExifOrientation: 6)
        } else if (image.imageOrientation == UIImage.Orientation.left) {
            return self.oriented(forExifOrientation: 6)
        } else if (image.imageOrientation == UIImage.Orientation.down) {
            return self.oriented(forExifOrientation: 3)
        } else if (image.imageOrientation == UIImage.Orientation.up) {
            return self.oriented(forExifOrientation: 1)
        }
        return self
    }
}
