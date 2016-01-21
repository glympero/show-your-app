//
//  DataService.swift
//  show-your-app-glympe
//
//  Created by Γιώργος Λυμπερόπουλος on 21/01/16.
//  Copyright © 2016 glympe. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static let ds = DataService()
    
    //Getting a reference to our firebase account
    private var _REF_BASE = Firebase(url: "https://showcase-your-app.firebaseio.com")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
}
