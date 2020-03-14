//
//  GETJSON.swift
//  AiBeautify
//
//  Created by xqj on 2019/10/22.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class GETJSON :Mappable
{
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        code <- map["code"]
        msg <- map["msg"]
    }
    
    var code: Int = 0
    var data: IntData = IntData()
    var msg: String = " "
    
}

