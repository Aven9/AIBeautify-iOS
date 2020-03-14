//
//  PathWithColor.swift
//  Alamofire
//
//  Created by xqj on 2019/10/18.
//

import Foundation
import AVFoundation
import ObjectMapper
//public protocol Equatable
//{
//    static func == (fisrt:Self,second:PathWithColor) ->Bool
//    static func == (fisrt:Self,second:PathWithNoColor) ->Bool
//}
open class PathWithColor :Equatable,Mappable
{
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        prev <- map["Prev"]
        curr <- map["Curr"]
        color <- map["color"]
    }
   
    var prev :SpecialPoint = SpecialPoint(point: CGPoint())
    var curr :SpecialPoint = SpecialPoint(point: CGPoint())
    var color :RGBStructure = RGBStructure(RED: 0.0, GREEN: 0.0, BLUE: 0.0)
    init(begin:SpecialPoint,end:SpecialPoint,brushColor:RGBStructure)
    {
        prev = begin
        curr = end
        color = brushColor
    }
    public static func == (lhs:PathWithColor,rhs:PathWithColor) ->Bool
    {
        if lhs.prev == rhs.prev
        {
            if lhs.curr == rhs.curr
            {
                if lhs.color == rhs.color
                {
                    return true
                }
            }
        }
        return false
    }
    
}
