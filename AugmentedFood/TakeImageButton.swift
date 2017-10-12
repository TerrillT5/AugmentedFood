//
//  TakeImageButton.swift
//  AugmentedFood
//
//  Created by Terrill Thorne on 10/12/17.
//  Copyright © 2017 Terrill Thorne. All rights reserved.
//

import UIKit

class TakeImageButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 4
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layer.masksToBounds = true 
    }
}
