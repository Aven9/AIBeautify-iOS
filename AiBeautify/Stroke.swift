//
//  Stroke.swift
//  AiBeautify
//
//  Created by xqj on 2019/10/21.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class Stroke:Mappable
{
    open var StrokeForUpload = [PathWithColor]()
    
    required init?(map: Map) {}
    
    func mapping(map: Map)
    {
       //type <- map["Type"]
       StrokeForUpload <- map[""]
    }
    init() {}
    
}
