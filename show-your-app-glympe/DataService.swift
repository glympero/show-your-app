//
//  DataService.swift
//  show-your-app-glympe
//
//  Created by Γιώργος Λυμπερόπουλος on 21/01/16.
//  Copyright © 2016 glympe. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://showcase-your-app.firebaseio.com"

class DataService {
    
    
    static let ds = DataService()
    
    //Getting a reference to our firebase account
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    
    private var _REF_POSTS = Firebase(url:"\(URL_BASE)/posts")
    
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_POSTS: Firebase {
        return _REF_POSTS
    }
    
    var REF_USERS: Firebase {
        return _REF_USERS
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        //Create a new firebase user in location firebase/users/(new user unique id - uid)
        REF_USERS.childByAppendingPath(uid).setValue(user)
        
    }
}
