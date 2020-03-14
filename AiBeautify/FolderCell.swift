//
//  FolderCell.swift
//  AiBeautify
//
//  Created by aUcid on 2019/5/1.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import FileKit
import CollectionKit
import MaterialComponents

class FolderCell: MDCCard {
    var imageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
        label = UILabel(frame: CGRect(x: 0, y: frame.width, width: frame.width, height: frame.height - frame.width))
        label.font = UIFont(name: "Helvetica", size: 13)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        label.frame = CGRect(x: 0, y: frame.width, width: frame.width, height: frame.height - frame.width)
        self.addSubview(imageView)
        self.addSubview(label)
    }
    
}
