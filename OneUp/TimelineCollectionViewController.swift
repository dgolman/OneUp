//
//  TimelineCollectionViewController.swift
//  OneUp
//
//  Created by Daniel Golman on 5/3/15.
//  Copyright (c) 2015 Daniel Golman. All rights reserved.
//

import UIKit

class TimelineCollectionViewController: PFQueryCollectionViewController {

    var challenges: [Int: PFObject] = [:]
    var selectedChallenge: PFObject!
    
    override func viewDidLoad() {
       
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        self.parseClassName = "Challenge"
        
        collectionView!.registerNib(UINib(nibName: "TimelineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimelineCell")
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: UIViewController
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let bounds = UIEdgeInsetsInsetRect(view.bounds, layout.sectionInset)
            let sideLength = min(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) - layout.minimumInteritemSpacing
            layout.itemSize = CGSizeMake(sideLength, sideLength/2)
        }
    }
    
    
    // MARK: Data
    
    override func queryForCollection() -> PFQuery {
        return super.queryForCollection().orderByAscending("createdAt")
    }
    
    // MARK: CollectionView
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        
        var cell:TimelineCollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier("TimelineCell", forIndexPath: indexPath) as? TimelineCollectionViewCell
        
        self.challenges[indexPath.row] = object
        
        if let pfObject = object {
            
            let handleOneImageFile = pfObject["challengerPhoto"] as! PFFile
            handleOneImageFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    cell?.firstHandleImageView.image = UIImage(data:imageData!)
                }
                
            })
            if pfObject["challengeePhoto"] != nil {
                let handleTwoImageFile = pfObject["challengeePhoto"] as! PFFile
                handleTwoImageFile.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        cell?.secondHandleImageView.image = UIImage(data:imageData!)
                    }
                    
                })
            }
           
        }
//        cell?.textLabel.textAlignment = .Center
        
//        if let title = object?["title"] as? String {
//            let attributedTitle = NSMutableAttributedString(string: title)
//            if var priority = object?["priority"] as? Int {
//                let attributes = [NSFontAttributeName : UIFont.systemFontOfSize(13.0), NSForegroundColorAttributeName : UIColor.grayColor()]
//                let string = NSAttributedString(string: "\nPriority: \(priority)", attributes: attributes)
//                attributedTitle.appendAttributedString(string)
//            }
//            cell?.textLabel.attributedText = attributedTitle
//        } else {
//            cell?.textLabel.attributedText = NSAttributedString()
//        }
        
        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedChallenge = challenges[indexPath.row]
        self.performSegueWithIdentifier("SelectedChallenge", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? SelectedChallengeTableViewController {
            destinationVC.challengeObject = selectedChallenge
        }
    }


}
