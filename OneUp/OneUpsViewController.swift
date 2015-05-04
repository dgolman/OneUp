//
//  OneUpsViewController.swift
//  OneUp
//
//  Created by Daniel Golman on 4/26/15.
//  Copyright (c) 2015 Daniel Golman. All rights reserved.
//

import UIKit

class OneUpsViewController: UIViewController {

    var selfieObjectId: String?
   
    @IBOutlet weak var numChallengersLabel: UILabel!
    @IBOutlet weak var selfieToOneUpImageView: UIImageView!
    
    @IBOutlet weak var votesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.setToolbarHidden(false, animated:true)
        
        var selfieQuery: PFQuery = PFQuery(className: "Selfie")
        selfieQuery.getObjectInBackgroundWithId(selfieObjectId!, block: { (selfie: PFObject?, error: NSError?) -> Void in
            var selfie: PFObject = selfie!
            var oneUps: PFRelation = selfie.relationForKey("OneUps")
            var query = oneUps.query()
            query?.countObjectsInBackgroundWithBlock(
                { (count: Int32, error: NSError?) -> Void in
                    self.numChallengersLabel.text = String("\(count) challengers")
                    var votes:Int? = selfie["votes"] as? Int
                    if votes == nil {
                        votes = 0
                    }
                    self.votesLabel?.text = "\(votes!) votes"
            })
        })
        
        
        // Do any additional setup after loading the view.
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
            
    }
    

}
