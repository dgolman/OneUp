//
//  SearchTableViewController.swift
//  OneUp
//
//  Created by Daniel Golman on 4/28/15.
//  Copyright (c) 2015 Daniel Golman. All rights reserved.
//

import UIKit

class SearchTableViewController: PFQueryTableViewController, UISearchBarDelegate {

    var users: [Int: PFUser] = [:]
    let cellIdentifier = "UserCell"
    var searchText = ""
    var imageFile: PFFile!
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 100
        
        self.parseClassName = "User"
        println(imageFile)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func queryForTable() -> PFQuery {
        var query:PFQuery = PFUser.query()!
        let objectId = PFUser.currentUser()?.objectId
        query.whereKey("objectId", notEqualTo: objectId!)
        if searchText.isEmpty {
            println("empty search")
        } else {
//            // username search
//            var nameSearch = query
//            nameSearch.whereKey("name", containsString: searchText)
            
            query.whereKey("handle", containsString: searchText)
            
//            println(query.getFirstObject())
//            // or them together
//            query = PFQuery.orQueryWithSubqueries([nameSearch, handleSearch])
            println("querying handle")
        }
        
        if(objects?.count == 0)
        {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        println("printing cell")
        var cell:PFTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        println(cell)
        users[indexPath.row] = object as? PFUser
        
        if let pfObject = object {
            cell?.textLabel?.text = pfObject["name"] as? String
            cell?.detailTextLabel!.text = pfObject["handle"] as? String
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedUser = users[indexPath.row]
        createChallenge(selectedUser!)
        performSegueWithIdentifier("Timeline", sender: nil)
    }
    
    func createChallenge(selectedUser: PFUser) {
        
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
                
                var currentLocation = manager.location
                var currentUser = PFUser.currentUser()
                var challenge: PFObject = PFObject(className: "Challenge")
                var challenger: String? = currentUser?.objectForKey("handle") as? String
                var challengee: String? = selectedUser.objectForKey("handle") as? String
                challenge.setObject(PFGeoPoint(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), forKey: "geolocation")
                challenge.setObject(challenger!, forKey: "challenger")
                challenge.setObject(challengee!, forKey: "challengee")
                challenge.setObject(0, forKey: "challengeeLikes")
                challenge.setObject(0, forKey: "challengerLikes")
                challenge.setObject(imageFile, forKey: "challengerPhoto")
                challenge.saveInBackground()
                
        }
        
        
    }
    
    // MARK: Search Bar
    // delegate in story board
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchText = searchBar.text
        self.loadObjects()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // add minimum length of search
        searchText = searchBar.text
        self.loadObjects()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // clear out search box
        searchBar.text = nil
        // clear out search variable
        searchText = ""
        // reload the table
        self.loadObjects()
        // hide keyboard
        searchBar.resignFirstResponder()
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
