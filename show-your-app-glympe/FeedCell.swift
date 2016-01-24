//
//  FeedCell.swift
//  show-your-app-glympe
//
//  Created by Γιώργος Λυμπερόπουλος on 23/01/16.
//  Copyright © 2016 glympe. All rights reserved.
//

import UIKit
import Alamofire

class FeedCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
//    @IBOutlet weak var likeImg: UIImageView!
//    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var appImg: UIImageView!
    
    var post: Post!
    
    //storing the request because we might need to cancel it
    var request: Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        appImg.clipsToBounds = true
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Post, img: UIImage?){
        self.post = post
        self.likes.text = "\(post.likes)"
        self.descriptionText.text = post.postDescription
        
        //If there is an image
        if post.imgUrl != nil {
            //Check if it cached and load it
            if img != nil {
                self.appImg.image = img
            //If it is not cached, get it
            }else{
                request = Alamofire.request(.GET, post.imgUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    if err == nil {
                        //Check with if let
                        let img = UIImage(data: data!)!
                        self.appImg.image = img
                        //Cache image
                        FeedVC.imageCache.setObject(img, forKey: post.imgUrl!)
                    }
                })
            }
        }else {
            //if there is no image
            self.appImg.hidden = true
        }
        
    }
    

}
