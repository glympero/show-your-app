//
//  FeedVC.swift
//  show-your-app-glympe
//
//  Created by Γιώργος Λυμπερόπουλος on 23/01/16.
//  Copyright © 2016 glympe. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    //Storing all posts
    var posts = [Post]()
    //Storing downloaded images
    static var imageCache = NSCache()
    //For image picker usage
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var postField: MaterialTextfield!
    @IBOutlet weak var imageSelector: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 340
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //navigationController.delegate = self
        
        //Listen for whenever anything changes in firebase - which informs appication instantly
        //.Value is called whenever data is changed - cmd-click to see different options
        //Because it is in a closure - it will only be called when data is changed
        //Just observe an eventtype on a path (firebaseapp/posts for example)
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: {snapshot in
            //print(snapshot.value)
            
            //empty array first because it'll be populated again from update
            self.posts = []
            //Grab all objects in the snapshot(snapshot is the data coming from firebase)
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    // snap.value - returns the data of this snapshot
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        //snap.key gives the ID(key) of every post - snap.value gives the content of this key-post (description, likes, imgUrl etc)
                        let key = snap.key
                        let post = Post(postId: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell") as? FeedCell{
            //If there is an request for an old item, cancel it because user is asking for a new cell
            cell.request?.cancel()
            var img: UIImage?
            
            if let url = post.imgUrl {
                //if image exists in the cache
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
            cell.configureCell(post, img: img)
            return cell
        }else{
            return FeedCell()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //if there is no image, reduce the cell height.
        let post = posts[indexPath.row]
        if post.imgUrl == nil {
            return 170
        }else{
            return tableView.estimatedRowHeight
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        //Assign the image selected to the image
        imageSelector.image = image
    }
    
    @IBAction func selectImage(sender: AnyObject) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func makePost(sender: AnyObject) {
    }
    
}
