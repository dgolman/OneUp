//
//  SelfieTableViewCell.swift
//  OneUp
//
//  Created by Daniel Golman on 4/24/15.
//  Copyright (c) 2015 Daniel Golman. All rights reserved.
//

import UIKit

class SelfieTableViewCell: PFTableViewCell {
    
    @IBOutlet weak var selfieImageView:UIImageView?
    @IBOutlet weak var selfieNameLabel:UILabel?
    @IBOutlet weak var selfieVotesLabel:UILabel?
    @IBOutlet weak var selfiePawIcon:UIImageView?
    
    var parseObject:PFObject?
    
    override func awakeFromNib() {
        let gesture = UITapGestureRecognizer(target: self, action:Selector("onDoubleTap:"))
        gesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(gesture)
        
        selfiePawIcon?.hidden = true
        super.awakeFromNib()
        // Initialization code
    }
    
    func onDoubleTap(sender:AnyObject) {
        selfiePawIcon?.hidden = false
        selfiePawIcon?.alpha = 1.0
        
        UIView.animateWithDuration(1.0, delay: 1.0, options: nil,
            animations: {
                self.selfiePawIcon?.alpha = 0.0
                return
            },
            completion: { (finished: Bool) in
                self.selfiePawIcon?.hidden = true
                return
            }
        )
        
        if(parseObject != nil) {
            if var votes:Int? = parseObject!.objectForKey("votes") as? Int {
                votes!++
                
                parseObject!.setObject(votes!, forKey: "votes");
                parseObject!.saveInBackground();
                
                selfieVotesLabel?.text = "\(votes!) votes";
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
