//
//  POSTJSON.swift
//  AiBeautify
//
//  Created by xqj on 2019/10/21.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import Foundation
import ObjectMapper
class PostJSON :Mappable
{
    open var MaskForUpload = [PathWithNoColor]()
    open var SketchForUpload = [PathWithNoColor]()
    open var StrokeForUpload = [PathWithColor]()
    //open var mask = Mask()
    //open var sketch = Sketch()
    //open var stroke = Stroke()
    open var id :Int = 0
    required init?(map: Map) {}
    func mapping(map: Map)
    {
        id <- map["id"]
        MaskForUpload <- map["mask"]
        SketchForUpload <- map["sketch"]
        StrokeForUpload <- map["stroke"]
//        mask <- map["mask"]
//        sketch <- map["sketch"]
//        stroke <- map["stroke"]
    }
    init() {}
    
}
