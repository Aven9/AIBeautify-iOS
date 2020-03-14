//
//  RGBCLASS.swift
//  MaLiang
//
//  Created by xqj on 2019/10/19.
//


import Foundation
import AVFoundation
import ObjectMapper

class RGBStructure:Mappable
{
    required init?(map: Map) {}
    
     func mapping(map: Map)
     {
        red <- map["Red"]
        green <- map["Green"]
        blue <- map["Blue"]
    }
    
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat  = 0.0
    init(RED:CGFloat,GREEN:CGFloat,BLUE:CGFloat)
    {
        red = RED
        green = GREEN
        blue = BLUE
    }
    static func == (first:RGBStructure,second:RGBStructure) ->Bool
    {
        if first.red == second.red
        {
            if first.green == second.green
            {
                if(first.blue==second.blue)
                {
                    return true
                }
            }
        }
        return false
    }
}
