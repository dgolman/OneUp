//
//  TimelineCollectionViewCell.swift
//  OneUp
//
//  Created by Daniel Golman on 5/3/15.
//  Copyright (c) 2015 Daniel Golman. All rights reserved.
//

import UIKit

class TimelineCollectionViewCell: PFCollectionViewCell {

    @IBOutlet weak var firstHandleImageView: UIImageView!
    @IBOutlet weak var secondHandleImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews()
    {
        self.cardSetup()
//        self.imageSetup()
    }
    
    func cardSetup()
    {
        self.cardView.alpha = 1
        self.cardView.layer.masksToBounds = false
        self.cardView.layer.cornerRadius = 1 // if you like rounded corners
        self.cardView.layer.shadowOffset = CGSizeMake(-0.2, 0.2) //%%% this shadow will hang slightly down and to the right
        self.cardView.layer.shadowRadius = 1 //%%% I prefer thinner, subtler shadows, but you can play with this
        self.cardView.layer.shadowOpacity = 0.2 //%%% same thing with this, subtle is better for me
        
        //%%% This is a little hard to explain, but basically, it lowers the performance required to build shadows.  If you don't use this, it will lag
        var path: UIBezierPath = UIBezierPath(rect: self.cardView.bounds)
        self.cardView.layer.shadowPath = path.CGPath;
        
        self.backgroundColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1)//%%% I prefer choosing colors programmatically than on the storyboard
    }
    
//    func imageSetup()
//    {
//        selfieImageView.layer.cornerRadius = selfieImageView.frame.size.width/2
//        selfieImageView.clipsToBounds = true
//        selfieImageView.contentMode = UIViewContentMode.ScaleAspectFit
//        selfieImageView.backgroundColor = UIColor.whiteColor()
//    }


}
