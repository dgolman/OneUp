//
//  RegisterLocationViewController.swift
//  OneUp
//
//  Created by Daniel Golman on 4/28/15.
//  Copyright (c) 2015 Daniel Golman. All rights reserved.
//

import UIKit
import CoreLocation

class RegisterLocationViewController: UIViewController {

    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func giveLocationButtonPressed(sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
        }
        
        if let user = PFUser.currentUser() {
            user.setObject(true, forKey: "registered")
            user.saveInBackground()
        }
        
        self.performSegueWithIdentifier("Timeline", sender: nil)
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
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
