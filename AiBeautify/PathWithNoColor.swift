//
//  PathWithNoColor.swift
//  Alamofire
//
//  Created by xqj on 2019/10/18.
//


import Foundation
import AVFoundation
import ObjectMapper

open class PathWithNoColor:Equatable,Mappable
{
    var prev :SpecialPoint = SpecialPoint(point: CGPoint())
    var curr :SpecialPoint = SpecialPoint(point: CGPoint())
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        prev <- map["Prev"]
        curr <- map["Curr"]
    }
    
    init(begin:SpecialPoint,end:SpecialPoint)
    {
        prev = begin
        curr = end
    }
    public static func == (lhs:PathWithNoColor,rhs:PathWithNoColor) ->Bool
    {
        if lhs.prev == rhs.prev
        {
            if lhs.curr == rhs.curr
            {
                    return true
            }
        }
        return false
    }
}

