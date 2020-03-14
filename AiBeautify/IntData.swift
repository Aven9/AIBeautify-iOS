//
//  IntData.swift
//  AiBeautify
//
//  Created by xqj on 2019/10/22.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import Foundation
import ObjectMapper
class IntData:Mappable
{
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
    }
    
    var id = 0;
    
    init() {}
}
