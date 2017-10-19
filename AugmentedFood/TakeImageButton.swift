//
//  TakeImageButton.swift
//  AugmentedFood
//
//  Created by Terrill Thorne on 10/12/17.
//  Copyright © 2017 Terrill Thorne. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class TakeImageButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
//        layer.cornerRadius = 4
        layer.cornerRadius = 10
        layer.borderWidth = 2
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOffset = CGSize(width: 0, height: 10)
//        button.layer.shadowRadius = 5
//        button.layer.shadowOpacity = 0.5 // transparency of the shadow
//        button.layer.frame = CGRect(x: self.frame.width - 20, y: 35, width: 50, height: 50)
//        button.frame = CGRect(x: self.view.frame.size.width - 60, y: 60, width: 50, height: 50)

        
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layer.masksToBounds = true 
    }
    
    }

