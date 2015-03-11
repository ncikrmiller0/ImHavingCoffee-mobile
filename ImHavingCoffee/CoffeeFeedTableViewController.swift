//
//  CoffeeFeedTableViewController.swift
//  ImHavingCoffee
//
//  Created by Nicholas Miller on 3/1/15.
//  Copyright (c) 2015 Nicholas Miller. All rights reserved.
//

import UIKit

class CoffeeFeedTableViewController: UITableViewController {

    
    
    var titles = [String]()
    var usernames = [String]()
    var images = [UIImage]()
    //var locations = [Strings]()
    var imageFiles = [PFFile]()
    
    var refresher: UIRefreshControl!
    
    @IBAction func followPage(sender: AnyObject) {
        
        self.performSegueWithIdentifier("following", sender: self)
        
    }
    @IBAction func addCup(sender: AnyObject) {
        
        self.performSegueWithIdentifier("post", sender: self)
        
    }
    
    
    @IBAction func calendar(sender: AnyObject) {
        
        self.performSegueWithIdentifier("coffeCount", sender: self)
        
    }
    
    @IBAction func fbUserLogout(sender: AnyObject) {
        
        PFUser.logOut()
        var currentUser = PFUser.currentUser() // this will now be nil
        
        println(PFUser.currentUser())
        
        self.performSegueWithIdentifier("fbUserLogout", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateFeed()
    
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
    }

    func refresh() {
        
        println("refreshed")
        
        updateFeed()
        
    }
    
    func updateFeed() {
        
        var getFollowedUsersQuery = PFQuery(className: "followers")
        
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser().username)
        getFollowedUsersQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                var followedUser = ""
                
                for object in objects {
                    
                    followedUser = object["following"] as String!
                    
                    var query = PFQuery(className:"Post")  // Post is the table for User Coffee Posts
                    query.whereKey("username", equalTo:followedUser)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]!, error: NSError!) -> Void in
                        if error == nil {
                            // The find succeeded.
                            println("Successfully retrieved \(objects.count) Posts.")
                            // Do something with the found objects
                            if let objects = objects as? [PFObject] {
                                for object in objects {
                                    println(object.objectId)
                                    
                                    self.titles.append(object["Title"] as String)
                                    self.usernames.append(object["name"] as String)
                                    self.imageFiles.append(object["imageFile"] as PFFile)
                                    
                                    self.tableView.reloadData()
                                    
                                }
                            }
                        }
                        
                        
                    }
                    
                }
                self.refresher.endRefreshing()
                
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return titles.count 
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 260
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var myCoffee:coffeePost = self.tableView.dequeueReusableCellWithIdentifier("myCoffee") as coffeePost
    
        myCoffee.title.text = titles[indexPath.row]
        myCoffee.username.text = usernames[indexPath.row]
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock{
            (imageData: NSData!, error: NSError!) -> Void in
         
            if error == nil {
            
            let image = UIImage(data: imageData)

            myCoffee.postedImage.image = image
            
            }
            
        }

        // Configure the cell...

        return myCoffee
    }

}
