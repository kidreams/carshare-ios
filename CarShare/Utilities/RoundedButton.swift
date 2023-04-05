//
//  RoundedButton.swift
//  CarShare
//
//  Created by nicholas on 3/26/23.
//

import UIKit

class RoundedButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setRoundedCorner()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setRoundedCorner()
    }
    
    func setRoundedCorner() {
//        self.layer.cornerCurve = .circular
        self.layer.cornerRadius = self.frame.height / 2
        self.tintColor = UIColor(named: "main-button-color")
        
        self.layer.masksToBounds = true
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.tintColor = UIColor(named: "main-button-color")
    }
}
