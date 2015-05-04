//
//  TimelineTableViewController.swift
//  OneUp
//
//  Created by Daniel Golman on 4/28/15.
//  Copyright (c) 2015 Daniel Golman. All rights reserved.
//

import UIKit

class TimelineTableViewController: PFQueryTableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
    var selfies: [Int: PFObject] = [:]
    var selectedSelfie: PFObject!
    let manager = CLLocationManager()
    var oneUpPressed:Bool = false
    var currentLocation: CLLocation!
    let cellIdentifier:String = "TimelineCell"
    var imagePicker: UIImagePickerController!
    var parseObject: PFObject?
    var fullRowHeight = CGFloat(241)
    
    override func viewDidLoad() {
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        
        self.parseClassName = "Challenge"
        self.tableView.rowHeight = fullRowHeight
        
        tableView.registerNib(UINib(nibName: "TimelineTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        super.viewDidLoad()
    }
    
    override func queryForTable() -> PFQuery {
        var query:PFQuery = PFQuery(className:self.parseClassName!)
        
//        if(objects?.count == 0)
//        {
//            query.cachePolicy = PFCachePolicy.CacheThenNetwork
//        }
        
        query.orderByDescending("createdAt")
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        if let pfObject = object {
            var firstHandle: String = (pfObject["challenger"] as? String)!
            var secondHandle: String = (pfObject["challengee"] as? String)!
            var user: PFUser = PFUser.currentUser()!
            
            if pfObject["challengeePhoto"] != nil {
                var cell:TimelineTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? TimelineTableViewCell
                
                
                if(cell == nil) {
                    cell = NSBundle.mainBundle().loadNibNamed("TimelineTableViewCell", owner: self, options: nil)[0] as? TimelineTableViewCell
                }
                
                var likesForHandleOne:Int? = pfObject["challengerLikes"] as? Int
                if likesForHandleOne == nil {
                    likesForHandleOne = 0
                }
                
                var likesForHandleTwo:Int? = pfObject["challengeelikes"] as? Int
                if likesForHandleTwo == nil {
                    likesForHandleTwo = 0
                }
                
                cell?.firstHandleLikes.text = "\(likesForHandleOne!) likes"
                cell?.secondHandleLikes.text = "\(likesForHandleTwo!) likes"
               
                let handleOneImageFile = pfObject["challengerPhoto"] as! PFFile
                handleOneImageFile.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        cell?.firstHandleImageView.image = UIImage(data:imageData!)
                    }
                    
                })
                
                let handleTwoImageFile = pfObject["challengeePhoto"] as! PFFile
                handleTwoImageFile.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        cell?.secondHandleImageView.image = UIImage(data:imageData!)
                    }
                    
                })
                return cell
            } else {
                
            }
            
        }
        
        return PFTableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedSelfie = selfies[indexPath.row]
        performSegueWithIdentifier("OneUps", sender: nil)
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
        let imageFile:PFFile = PFFile(data: imageData)
        
        parseObject!.setObject(imageFile, forKey: "challengeePhoto")
        parseObject!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if(success) {
                self.loadObjects()
                self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
            } else {
                println("error")
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? OneUpsViewController {
            let selfieImageFile = selectedSelfie["photo"] as! PFFile
            selfieImageFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    destinationVC.selfieToOneUpImageView.image = UIImage(data:imageData!)
                }
                
            })
            destinationVC.selfieObjectId = selectedSelfie.objectId
            println(destinationVC.selfieObjectId)
        }
        
    }
    
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let unitFlags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekOfYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitSecond
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components(unitFlags, fromDate: earliest, toDate: latest, options: nil)
        
        if (components.year >= 2) {
            return "\(components.year) years ago"
        } else if (components.year >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month >= 2) {
            return "\(components.month) months ago"
        } else if (components.month >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear) weeks ago"
        } else if (components.weekOfYear >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day >= 2) {
            return "\(components.day) days ago"
        } else if (components.day >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour >= 2) {
            return "\(components.hour) hours ago"
        } else if (components.hour >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute >= 2) {
            return "\(components.minute) minutes ago"
        } else if (components.minute >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second >= 3) {
            return "\(components.second) seconds ago"
        } else {
            return "Just now"
        }
        
    }
        
    


}
