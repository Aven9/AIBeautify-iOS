//
//  SettingPencilViewController.swift
//  AiBeautify
//
//  Created by 张文洁 on 2019/6/1.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import UIKit

protocol SettingPencilViewControllerDelegate: class {
    
    func settingPencilViewControllerFinished(_ settingPencilViewController: SettingPencilViewController)
    
}

class SettingPencilViewController: UIViewController {
    
    @IBOutlet weak var preView: UIView!
    
    @IBOutlet var widthButtons: [UIButton]!

    @IBOutlet var colorButtons: [UIButton]!
    
    @IBOutlet weak var brushSlider: UISlider!
    
    @IBOutlet weak var brushLabel: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var detailView: DetailColorPickerView!
    
    var brush: CGFloat!
    var color: UIColor!

    
    weak var delegate: SettingPencilViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.settingPencilViewControllerFinished(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        preferredContentSize = self.view.frame.size
        brushSlider.setThumbImage(#imageLiteral(resourceName: "pencil_slider"), for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    // MARK: - Actions
    
    @IBAction func brushChanged(_ sender: UIButton) {
        if sender.tag < 3 {
            brush = sender.getWidth(tag: sender.tag)
        } else if sender.tag == 3 {
            color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            brush = 12
        } else {
            color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            brush = 4.8
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.preferredContentSize = preView.frame.size
            break
        default:
            self.preferredContentSize = detailView.frame.size
        }
        
        super.dismiss(animated: flag, completion: completion)
    }

    @IBAction func colorChanged(_ sender: UIButton) {
        color = sender.backgroundColor
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SliderChanged(_ sender: UISlider) {
        brush = CGFloat(sender.value)
        brushLabel.font = brushLabel.font.withSize(CGFloat(brush*5))
        brushLabel.textAlignment = .center
        brushLabel.setNeedsDisplay()
    }
    
    @IBAction func changeView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            if detailView.delegate == nil {
                detailView.delegate = self
            }
            preView.isHidden = true
            detailView.isHidden = false
            self.view.bringSubviewToFront(preView)
            self.preferredContentSize = detailView.frame.size
            moveSegmentedControl()
        } else {
            
            preView.isHidden = false
            detailView.isHidden = true
            self.view.bringSubviewToFront(detailView)
            self.preferredContentSize = preView.frame.size
            moveSegmentedControl()
        }
        self.view.setNeedsDisplay()
    }
    
    private func moveSegmentedControl() {
        segmentedControl.center.x = self.preferredContentSize.width/2
        segmentedControl.setNeedsDisplay()
    }
}

extension SettingPencilViewController : ColorPickerDelegate {
    func ColorPickerTouched(sender: DetailColorPickerView, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        self.color = color
        self.dismiss(animated: true, completion: nil)
    }
}


