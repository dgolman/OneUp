//
//  SelfieTableViewController.swift
//  OneUp
//
//  Created by Daniel Golman on 4/24/15.
//  Copyright (c) 2015 Daniel Golman. All rights reserved.
//


class SelfieTableViewController: PFQueryTableViewController {
    let cellIdentifier:String = "SelfieCell"
    
    override func viewDidLoad() {
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        
        self.parseClassName = "Selfie"
        self.tableView.rowHeight = 350
        self.tableView.allowsSelection = false
        
        tableView.registerNib(UINib(nibName: "SelfieTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)

        super.viewDidLoad()
    }
    
    override func queryForTable() -> PFQuery {
        var query:PFQuery = PFQuery(className:self.parseClassName!)
        
        if(objects?.count == 0)
        {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        query.orderByAscending("name")
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        var cell:SelfieTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? SelfieTableViewCell

        
        if(cell == nil) {
            cell = NSBundle.mainBundle().loadNibNamed("SelfieTableViewCell", owner: self, options: nil)[0] as? SelfieTableViewCell
        }
        
        cell?.parseObject = object
        
        if let pfObject = object {
            cell?.selfieNameLabel?.text = pfObject["name"] as? String
            
            var votes:Int? = pfObject["votes"] as? Int
            if votes == nil {
                votes = 0
            }
            cell?.selfieVotesLabel?.text = "\(votes!) votes"
            
            let selfieImageFile = pfObject["photo"] as PFFile
            selfieImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData!, error: NSError!) -> Void in
                if error == nil {
                    cell?.selfieImageView?.image = UIImage(data:imageData)
                    // do something with image here
                }
            }
            
            
            
        }
        
        
        return cell
    }
    
    @IBAction func cameraButtonPressed(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("SELFIE", sender: nil)
        
    }
    
    
}
