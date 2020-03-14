//
//  SpecialPoint.swift
//  MaLiang
//
//  Created by xqj on 2019/10/18.
//

import Foundation
import AVFoundation
import ObjectMapper
open class SpecialPoint:Mappable,Equatable
{
    open var X:Int = 0
    open var Y:Int = 0
    
    init(point:CGPoint)
    {
        
        let x=Int(round(point.x))
        let y=Int(round(point.y))
        X=x;
        Y=y;
    }
    public required init?(map: Map){}
    
    public func mapping(map: Map) {
        X    <- map["X"]
        Y    <- map["Y"]
    }
    
    
    
    public static func == (lhs:SpecialPoint,rhs:SpecialPoint) ->Bool
    {
        if lhs.X == rhs.X
        {
            if lhs.Y == rhs.Y
            {
                return true
            }
        }
        return false
    }
    open func enoughDistance(second:SpecialPoint) ->Bool
    {
        let dis = (X-second.X)*(X-second.X)+(Y-second.Y)*(Y-second.Y)
        if dis>100
        {
            return true
        }
        return false
    }
}
