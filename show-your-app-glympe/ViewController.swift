//
//  ViewController.swift
//  show-your-app-glympe
//
//  Created by Γιώργος Λυμπερόπουλος on 20/01/16.
//  Copyright © 2016 glympe. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var emailField: MaterialTextfield!
    @IBOutlet weak var passwordField: MaterialTextfield!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil){
            self.performSegueWithIdentifier(SEGUE_LOG_IN, sender: nil)
        }
    }
    
    @IBAction func fbBtnPressed(sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Success. \(accessToken)")
                
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    if error != nil {
                        print("Login Failed")
                    }else{
                        print("Loggged in \(authData)")
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        if let provider = authData.provider, uid = authData.uid {
                            let user = ["provider" : provider]
                            let userUid = uid
                            self.userSignUpAndLogin(userUid, user: user)
//                            DataService.ds.createFirebaseUser(userUid, user: user)
//                            self.performSegueWithIdentifier(SEGUE_LOG_IN, sender: nil)
                        }
                        else{
                            self.showAlert("Cannot create user", msg: "Please try again. Account not created")
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func loginBtnPressed(sender: AnyObject) {
        if let email = emailField.text where emailField.text != "", let password = passwordField.text where passwordField.text != "" {
            DataService.ds.REF_BASE.authUser(email, password: password, withCompletionBlock: { error, authData in
                if error != nil {
                    print(error)
                    if error.code == STATUS_ACCOUNT_NONEXIST{
                        //if account does not exist, create new user
                        DataService.ds.REF_BASE.createUser(email, password: password, withValueCompletionBlock: { error, result in
                            //Check error codes
                            if error != nil {
                                //Check if account already exists, or problem with password (not enough chars) - TODO!!!!
                                self.showAlert("Cannot Create Account", msg: "Please try different username and/or password")
                            }else{
                                //If all ok - save user id and login (result[KEY_UID] instead of result.uid because it is a dictionary
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                //We dont check for errors as we just created a new user account (could add check if needed though
                                //DataService.ds.REF_BASE.authUser(email, password: password, withCompletionBlock: nil)
                                DataService.ds.REF_BASE.authUser(email, password: password, withCompletionBlock: { err, authData in
                                    if let provider = authData.provider, uid = authData.uid {
                                        let user = ["provider" : provider]
                                        let userUid = uid
                                        self.userSignUpAndLogin(userUid, user: user)
//                                        DataService.ds.createFirebaseUser(userUid, user: user)
                                        
                                    }
                                    else{
                                        self.showAlert("Cannot create user", msg: "Please try again. Account not created")
                                    }

                                })
                                //self.performSegueWithIdentifier(SEGUE_LOG_IN, sender: nil)
                                //self.userLogin()
                            }
                        })
                    } else {
                        self.showAlert("Could not Login", msg: "Please check username or password")
                    }
                }else {
                    //If first email and password are valid and user has an account
                    self.userLogin()
                }
            })
        }else {
            showAlert("Invalid Login In", msg: "Please enter a valid email and password")
        }
        
    }
    
    func showAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func userLogin(){
        
        performSegueWithIdentifier(SEGUE_LOG_IN, sender: nil)
    }
    
    func userSignUpAndLogin(uid: String, user: Dictionary<String, String>){
        DataService.ds.createFirebaseUser(uid, user: user)
        performSegueWithIdentifier(SEGUE_LOG_IN, sender: nil)
    }


}

