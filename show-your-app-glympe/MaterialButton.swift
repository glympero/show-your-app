//
//  MaterialButton.swift
//  show-your-app-glympe
//
//  Created by Γιώργος Λυμπερόπουλος on 20/01/16.
//  Copyright © 2016 glympe. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        //How much to cover with shadow
        layer.shadowRadius = 10.0
        //0 for x (because we want to be equaly shown on left and right - so we have larger radious)
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }


}
