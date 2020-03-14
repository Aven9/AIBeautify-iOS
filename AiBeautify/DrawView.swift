//
//  DrawView.swift
//  AiBeautify
//
//  Created by 张文洁 on 2019/7/10.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import UIKit
import MaLiang
import Foundation
import AVFoundation
import Alamofire
import ObjectMapper

class DrawView: UIView {
    
    var canvas: Canvas!
    var imageData: UIImage!
    var imageView: UIImageView!
    var backgroundImage: UIImage? {
        didSet { setNeedsDisplay() }
    }

    public init(image: UIImage?, frame: CGRect) {
        super.init(frame: frame)
        imageData = image ?? nil
        prepareImageView()
        prepareCanvas()
        uploadPicture()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isMultipleTouchEnabled=true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundImage?.draw(in: bounds)
        
    }
    
    
    private func uploadPicture()
    {
        
        let image = self.imageData!
        let jpegImage = image.jpegData(compressionQuality: 1)!
        //var id = 0
        let url = "http://39.106.33.139:5000/image/upload"
        //var responseString = ""
        AF.upload(multipartFormData:{ multipartFormData in multipartFormData.append(jpegImage, withName: "file", fileName: "1.jpg", mimeType: "image/jpeg")},to: url).responseString
                    { response in
                        //id = response.data
                        //print("啊啊啊啊啊id\(response.result)")
                        debugPrint(response)
                        
                        if let responseJson = Mapper<GETJSON>().map(JSONString: response.value!)
                        {
                           let responseJsonData = responseJson.data
                            POSTJSON.id = responseJsonData.id
                        }
        }
        
         }
    
    private func prepareColorType()
    {
        let redCompoment = canvas.currentBrush.color.r()
        let greenCompoment = canvas.currentBrush.color.g()
        let blueCompoment = canvas.currentBrush.color.b()
        colorRGB = RGBStructure(RED: redCompoment, GREEN: greenCompoment, BLUE: blueCompoment)
        if(colorRGB == whiteRGB)
        {
            ColorType = .white
        }
        else if(colorRGB == blackRGB)
        {
            ColorType = .black
        }
        else {ColorType = .others}
    }
    
    private func fillPathArray()
    {
        switch ColorType
        {
        case .white:
            let uploadPath = PathWithNoColor(begin: PrevPoint, end: CurrPoint)
            if !POSTJSON.MaskForUpload.contains(uploadPath)
            {
                POSTJSON.MaskForUpload.append(uploadPath)
                //print("Ma:\(POSTJSON.MaskForUpload)")
            }
            PrevPoint = CurrPoint
        case .black:
            let uploadPath = PathWithNoColor(begin: PrevPoint, end: CurrPoint)
            if !POSTJSON.SketchForUpload.contains(uploadPath)
            {
                POSTJSON.SketchForUpload.append(uploadPath)
                //print("Sk:\(POSTJSON.SketchForUpload)")
            }
            PrevPoint = CurrPoint
            
        case .others:
            let uploadPath = PathWithColor(begin: PrevPoint, end: CurrPoint, brushColor: colorRGB)
            if !POSTJSON.StrokeForUpload.contains(uploadPath)
            {
                POSTJSON.StrokeForUpload.append(uploadPath)
                //print("St:\(POSTJSON.StrokeForUpload)")
            }
            PrevPoint = CurrPoint
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for item in touches
        {
            let x = item.location(in: canvas).x*Xrate
            let y = item.location(in: canvas).y*Yrate
            let location = CGPoint(x: x,y: y)
            print(location)
            PrevPoint = SpecialPoint(point: location)
            
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for item in touches
        {
            let x = item.location(in: canvas).x*Xrate
            let y = item.location(in: canvas).y*Yrate
            let location = CGPoint(x: x,y: y)
            print(location)
            CurrPoint = SpecialPoint(point: location)
            if PrevPoint.enoughDistance(second: CurrPoint)
            {
                prepareColorType()
                fillPathArray()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        for item in touches
        {
            let x = item.location(in: canvas).x*Xrate
            let y = item.location(in: canvas).y*Yrate
            let location = CGPoint(x: x,y: y)
            print(location)
            CurrPoint = SpecialPoint(point: location)
            if PrevPoint.enoughDistance(second: CurrPoint)
            {
                fillPathArray()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for item in touches
        {
            let x = item.location(in: canvas).x*Xrate
            let y = item.location(in: canvas).y*Yrate
            let location = CGPoint(x: x,y: y)
            print(location)
            CurrPoint = SpecialPoint(point: location)
            if PrevPoint.enoughDistance(second: CurrPoint)
            {
                fillPathArray()
            }
        }
    }
    
      
    private func prepareCanvas() {
        let rect = AVMakeRect(aspectRatio: imageView.image?.size ?? imageData.size, insideRect: imageView.bounds)
        Xrate = pictureSize/rect.width
        Yrate = pictureSize/rect.height
        canvas = Canvas(frame: rect)
        self.addSubview(canvas)
        self.bringSubviewToFront(canvas)
    }
    
    override func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
        var au = afterUpdates
        if !afterUpdates && self.window == nil {
            au = true
        }
        return super.snapshotView(afterScreenUpdates: au)
    }
    
    private func prepareImageView() {
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFit
        if let image = imageData {
            imageView.image = image
        }
        self.addSubview(imageView)
    }
    
    public func combineImage() -> UIImage {
        var sketch: UIImage?
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            let rect = self.frame(for: self.imageData, inImageViewAspectFit: self.imageView)
            
            let compressImg = self.imageWithImage(sourceImage: self.canvas.snapshot()!, scaledToWidth: self.bounds.size.width)
            
            let image = self.cropToBounds(image: compressImg,                                                               width: rect.size.width,
                                          height: rect.size.height,
                                          x: 0,
                                          y: 0)
            
            sketch = self.imageWithImage(sourceImage: self.imageData, scaledToWidth: self.bounds.size.width)
                .overlayWith(image: image, posX: 0, posY: 0)
            
            group.leave()
        }
        
        group.wait()
        
        if sketch != nil {
            return sketch!
        }
        
        return imageData
    }
    
    func frame(for image: UIImage, inImageViewAspectFit imageView: UIImageView) -> CGRect {
        let imageRatio = (image.size.width / image.size.height)
        let viewRatio = imageView.frame.size.width / imageView.frame.size.height
        if imageRatio < viewRatio {
            let scale = imageView.frame.size.height / image.size.height
            let width = scale * image.size.width
            let topLeftX = (imageView.frame.size.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageView.frame.size.height)
        } else {
            let scale = imageView.frame.size.width / image.size.width
            let height = scale * image.size.height
            let topLeftY = (imageView.frame.size.height - height) * 0.5
            return CGRect(x: 0.0, y: topLeftY, width: imageView.frame.size.width, height: height)
        }
    }
    
    func cropToBounds(image: UIImage, width: CGFloat, height: CGFloat, x: CGFloat, y: CGFloat) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
                var posX: CGFloat = x
        var posY: CGFloat = y
        var w = width
        var h = height
        
        if contextSize.height > height {
            h = height
            posY = (contextSize.height-height)/2
        }
        if contextSize.width > width {
            w = width
            posX = (contextSize.width-width)/2
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: w, height: h)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func imageWithImage (sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    
}
