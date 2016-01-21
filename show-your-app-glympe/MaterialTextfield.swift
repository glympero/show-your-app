//
//  MaterialTextfield.swift
//  show-your-app-glympe
//
//  Created by Γιώργος Λυμπερόπουλος on 20/01/16.
//  Copyright © 2016 glympe. All rights reserved.
//

import UIKit

class MaterialTextfield: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.3).CGColor
        layer.borderWidth = 1.0
    }
    
    //Moving placeholder to the right
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        //10 to the x, 0 to y
        return CGRectInset(bounds, 10, 0)
    }
    
    //Moving text
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
}
