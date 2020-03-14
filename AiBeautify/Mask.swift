//
//  Mask.swift
//  AiBeautify
//
//  Created by xqj on 2019/10/21.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import Foundation
import ObjectMapper

//class Mask:Mappable
//{
//
//
//    //var type : String = "Mask"
//    open var MaskForUpload = [PathWithNoColor]()
//
//    required init?(map: Map) {}
//
////    func mapping(map: Map)
////    {
////       //type <- map["Type"]
////       MaskForUpload <- map[""]
////    }
//    init() {}
//
//}
class Mask:Mappable
{
    
    
    //var type : String = "Mask"
    open var MaskForUpload = [PathWithNoColor]()
    
    required init?(map: Map) {}
    
    func mapping(map: Map)
    {
       //type <- map["Type"]
       MaskForUpload <- map[""]
    }
    init() {}
    
}
