//
//  LoginViewController.swift
//  OneUp
//
//  Created by Daniel Golman on 4/24/15.
//  Copyright (c) 2015 Daniel Golman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
            self.performSegueWithIdentifier("SELFIES", sender: nil)
        }
        
    }

    @IBAction func FBLoginPressed(sender: UIButton) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    self.performSegueWithIdentifier("SELFIES", sender: nil)
                } else {
                    self.performSegueWithIdentifier("SELFIES", sender: nil)
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
