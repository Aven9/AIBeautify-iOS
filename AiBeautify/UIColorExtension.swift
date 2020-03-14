//
//  UIColorExtension.swift
//  MaLiang
//
//  Created by xqj on 2019/10/19.
//

import Foundation
import AVFoundation
import UIKit
extension UIColor {
    
    func r() -> CGFloat {
        
        return self.cgColor.components![0];
    }
    
    func g() -> CGFloat {
        
        let count = self.cgColor.numberOfComponents;
        if (count == 2) {
            return self.cgColor.components![0];
        } else {
            return self.cgColor.components![1];
        }
    }
    
    func b() -> CGFloat {
        
        let count = self.cgColor.numberOfComponents;
        if (count == 2) {
            return self.cgColor.components![0];
        } else {
            return self.cgColor.components![2];
        }
    }
    
    func a() -> CGFloat {
        
        let count = self.cgColor.numberOfComponents;
        return self.cgColor.components![count - 1];
    }
}
