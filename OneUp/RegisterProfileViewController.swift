//
//  RegisterProfileViewController.swift
//  OneUp
//
//  Created by Daniel Golman on 4/28/15.
//  Copyright (c) 2015 Daniel Golman. All rights reserved.
//

import UIKit

class RegisterProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var handleField: UITextField!
    var user: PFUser!
    
    override func viewDidLoad() {
        
        self.user = PFUser.currentUser()
        
        self.handleField.text = user["handle"] as? String
        
        var request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        
        request.startWithCompletionHandler({ (connection: FBSDKGraphRequestConnection!, id result, error: NSError!) -> Void in
            if (error == nil) {
                var userData = result as? NSDictionary
                var name: String = userData?["name"] as! String
                self.user?.setObject(name, forKey: "name")
                self.nameField.text = name
                var facebookId:String = userData?["id"] as! String
                var profile_url = "https://graph.facebook.com/"+facebookId+"/picture?type=large&return_ssl_resources=1"
                self.user?.setObject(profile_url, forKey: "profile_url")
                self.user?.saveInBackground()
                
                var pictureURL: NSURL = NSURL(string: profile_url)!
                
                var urlRequest: NSURLRequest = NSURLRequest(URL: pictureURL)
                
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                   
                    if (error == nil && data != nil) {
                        self.profileImageView.image = UIImage(data: data)
                    }
                })
            }
        })
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text == self.handleField.text {
            var currentText: String = textField.text
            var handleIndex = currentText.startIndex
            if currentText == "" || currentText[handleIndex] != "@" {
                var handle: Character = "@" as Character
                currentText.append(handle as Character)
                let newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
                currentText += newString
                textField.text = currentText
                return false
            }
            return true
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    @IBAction func continueButtonPressed(sender: UIButton) {
        
        var handle = self.handleField.text
        user.setObject(handle, forKey: "handle")
        user.saveInBackground()
        self.performSegueWithIdentifier("RegisterLocation", sender: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
