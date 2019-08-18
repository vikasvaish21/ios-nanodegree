//
//  Button.swift
//  MarvelComics
//
//  Created by vikas on 13/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable
class Button: UIButton {
    var bgColor = UIColor(named: "secondary")!.cgColor
    var height = 45.0
    var cornerRadius: CGFloat = 22.5
    
    @IBInspectable
    var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
            self.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        setup()
        super.layoutSubviews()
    }
    
    func setup() {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.backgroundColor = bgColor
        frame.size = CGSize(width: Double(frame.size.width), height: height)
        titleLabel?.font = UIFont(name: "Avenir Next", size: 16)
    }
}
