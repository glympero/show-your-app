//
//  Post.swift
//  show-your-app-glympe
//
//  Created by Γιώργος Λυμπερόπουλος on 24/01/16.
//  Copyright © 2016 glympe. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _postId: String!
    private var _postDescription: String!
    private var _imgUrl: String?
    private var _likes: Int
    private var _username: String!
    private var _postRef: Firebase!
    
    var username: String {
        return _username
    }
    
    var postId: String {
        return _postId
    }
    
    var postDescription: String {
        return _postDescription
    }
    
    var imgUrl: String? {
        return _imgUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postRef: Firebase {
        return _postRef
    }
    
    //This initializer is used when user creates post in the app
    init(postDescription: String, imgUrl: String?, username: String){
        self._postDescription = postDescription
        self._imgUrl = imgUrl
        self._username = username
        self._likes = 0
    }
    
    //This initializer is used when we grab data from firebase
    init(postId: String, dictionary: Dictionary<String, AnyObject>) {
        self._postId = postId
        
        if let description = dictionary["description"] as? String{
            self._postDescription = description
        }
        if let imgUrl = dictionary["imageUrl"] as? String {
            self._imgUrl = imgUrl
        }
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }else {
            self._likes = 0
        }
        self._postRef = DataService.ds.REF_POSTS.childByAppendingPath(self._postId)
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
                
        }else {
                _likes = _likes - 1
        }
        
        _postRef.childByAppendingPath("likes").setValue(_likes)
    }
}
