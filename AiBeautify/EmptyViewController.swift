//
//  EmptyViewController.swift
//  AiBeautify
//
//  Created by aUcid on 2019/5/1.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import UIKit
import UIImageColors

class EmptyViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    internal var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        timer = Timer(timeInterval: TimeInterval(exactly: 5.0)!, repeats: true) { (timer) in
            self.setupBackground()
        }
        
        timer.fire()   
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    private func setupBackground() {
        let imgName = "empty\(Int.random(in: 0...4))"
        print(imgName)
        let img = UIImage(named: imgName)!
        img.getColors { colors in
            self.view.backgroundColor = colors?.background
            self.mainLabel.textColor = colors?.primary
        }
        imageView.image = img
    }
    
}
