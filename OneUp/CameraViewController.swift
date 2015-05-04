//
//  CameraViewController.swift
//  OneUp
//
//  Created by Daniel Golman on 4/28/15.
//  Copyright (c) 2015 Daniel Golman. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!
    var imageFile: PFFile?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)

        // Do any additional setup after loading the view.
    }
    
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let pickedImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Resize the image to be square (what is shown in the preview)
        var imageObbj:UIImage! =   self.imageResize(pickedImage, sizeChange: CGSizeMake(320,320))
        let imageData = UIImageJPEGRepresentation(imageObbj, 0.8)
        imageFile = PFFile(data: imageData)
        
        self.imagePicker.dismissViewControllerAnimated(true, completion: {
            println("finished Image")
//            let searchController = SearchTableViewController()
//            searchController.imageFile = self.imageFile
//            let navigationController = UINavigationController(rootViewController:searchController)
//            self.presentViewController(navigationController, animated: true, completion: nil)
            self.performSegueWithIdentifier("Search", sender: nil)
        })

        
//        var selfie: PFObject = PFObject(className: self.parseClassName!)
//        selfie.setObject(imageFile, forKey: "photo")
//        var user = PFUser.currentUser()
//        var name:String = (user!.objectForKey("name") as? String)!
//        selfie.setObject(name, forKey: "name")
//        selfie.setObject(PFGeoPoint(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), forKey: "geolocation")
//        selfie.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            if(success) {
//                self.loadObjects()
//                self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
//            } else {
//                println("error")
//            }
//        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? SearchTableViewController {
            destinationVC.imageFile = imageFile
            println(destinationVC.imageFile)
        }
        
    }


}
