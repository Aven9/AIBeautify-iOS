//
//  URLData.swift
//  AiBeautify
//
//  Created by xqj on 2019/10/22.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//


import Foundation
import ObjectMapper
class URLData:Mappable
{
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        url <- map["url"]
    }
    
    var url = ""
    
    init() {}
}
