//
//  FollowingTableViewController.swift
//  ImHavingCoffee
//
//  Created by Nicholas Miller on 2/27/15.
//  Copyright (c) 2015 Nicholas Miller. All rights reserved.
//

import UIKit

class FollowingTableViewController: UITableViewController {

    
    var users = [""]
    var usernames = [String]()
    //var images = [UIImage]()
    //var imageFiles = [PFFile]()
    //var locations = [Strings]()
    
    var following = [Bool]()
    
    var refresher: UIRefreshControl!
    
    @IBAction func fbUserLogout(sender: AnyObject) {
        
        PFUser.logOut()
        
        var currentUser = PFUser.currentUser() // this will now be nil
        
        println(PFUser.currentUser()["name"])
        
        self.performSegueWithIdentifier("fbUserLogout", sender: self)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        println(PFUser.currentUser()["name"])
        
        updateUsers()
        
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
    }
    
    func refresh() {
        
        println("refreshed")
        
        updateUsers()
        
    }

    func updateUsers() {
        
        var query = PFUser.query()
        
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            
            self.users.removeAll(keepCapacity: true)
            
            for object in objects {
                
                var user:PFUser = object as PFUser
                
                var isFollowing:Bool
                
                if user.username != PFUser.currentUser().username {
                    
                    self.users.append(user["name"] as String)
                    self.usernames.append(user.username)
                    //self.usernames.append(object["username"] as String)
                    //self.imageFiles.append(object["image"] as PFFile)
                    
                    isFollowing = false
                    
                    var query = PFQuery(className:"followers")
                    query.whereKey("follower", equalTo:PFUser.currentUser().username)
                    query.whereKey("following", equalTo:user.username)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]!, error: NSError!) -> Void in
                        if error == nil {
                            
                            println("Successfully retrieved \(objects.count) users.")
                            
                            for object in objects {
                                
                            
                                isFollowing = true
                                
                            }
                            self.following.append(isFollowing)
                            
                            self.tableView.reloadData()

                            
                            
                        } else {
                            // Log details of the failure
                            println(error)
                        }

                        
                        self.refresher.endRefreshing()
                        
                        
                    }
                    
                }
                
            }
            
            
            
        })

        
    }
    
override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(following)
        return users.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:followCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as followCell
        
        
        if following.count > indexPath.row {
            
            if following[indexPath.row] == true {
                
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                
                //cell.followMark.image = UIImage(contentsOfFile: "check-mark-green.png")
                
             
            }

            cell.userName?.text = users[indexPath.row]
         
            }

        return cell
        
    }

     /*
    
                
            }

        }
        */

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        //var myCell:followCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as followCell
        
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
        //if myCell.followMark.image == UIImage(named: "check-mark-green.png") {
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            //myCell.followMark.image = UIImage(named: "followed.png")
            
            var query = PFQuery(className:"followers")
            query.whereKey("follower", equalTo:PFUser.currentUser().username)
            query.whereKey("following", equalTo: self.usernames[indexPath.row])
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    
                    for object in objects {
                        
                        object.delete()
                        
                    }
                } else {
                    // Log details of the failure
                    println(error)
                }
            }
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            //myCell.followMark.image = UIImage(named: "check-mark-green.png")
            // try to set the image to a green check mark here!
            //self.followMark = UIImage("checked-mark-green")
            
            var following = PFObject(className: "followers")
            following["following"] = self.usernames[indexPath.row]
            following["follower"] = PFUser.currentUser().username
            
            following.save()
            
        }
        
    }
    
}