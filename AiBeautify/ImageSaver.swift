//
//  ImageSaver.swift
//  AiBeautify
//
//  Created by 张文洁 on 2019/7/7.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import Foundation

struct ImageSaver: Codable {
    // url for img
    var url: URL

    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(ImageSaver.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    var json: Data?
    {
        return try? JSONEncoder().encode(self)
    }
    
    init(url: URL) {
        self.url = url
    }
    
}
