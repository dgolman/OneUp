//
//  LoginViewController.swift
//  OneUp
//
//  Created by Daniel Golman on 4/24/15.
//  Copyright (c) 2015 Daniel Golman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
//        PFUser.logOut()
        if let user = PFUser.currentUser() {
            if let registered = user["registered"] as? Bool {
                if (registered == true) {
                    if FBSDKAccessToken.currentAccessToken() != nil {
                        self.performSegueWithIdentifier("Timeline", sender: nil)
                    } else {
                        println("NOT VALID TOKEN")
                    }
                }
            }
        }
        
        super.viewDidAppear(animated)
        
    }

    @IBAction func FBLoginPressed(sender: UIButton) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["user_about_me"], block: {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    self.performSegueWithIdentifier("RegisterProfile", sender: nil)
                } else {
                    var registered = user["registered"] as? Bool
                    if registered != nil  {
                        if (registered == true) {
                            self.performSegueWithIdentifier("Timeline", sender: nil)
                        } else {
                            self.performSegueWithIdentifier("RegisterProfile", sender: nil)
                        }
                    } else {
                        self.performSegueWithIdentifier("RegisterProfile", sender: nil)
                    }
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//
//    }


}
