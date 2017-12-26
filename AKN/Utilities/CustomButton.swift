//
//  CustomButton.swift
//  AKN
//
//  Created by Chhaileng Peng on 12/25/17.
//  Copyright © 2017 Chhaileng Peng. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {

    @IBInspectable var cornerButton: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerButton
            layer.masksToBounds = cornerButton > 0
        }
    }
    
}
