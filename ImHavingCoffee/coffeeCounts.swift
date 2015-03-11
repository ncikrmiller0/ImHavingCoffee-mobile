//
//  coffeeCounts.swift
//  ImHavingCoffee
//
//  Created by Nicholas Miller on 3/8/15.
//  Copyright (c) 2015 Nicholas Miller. All rights reserved.
//

import UIKit

class coffeeCounts: UIViewController {

    @IBOutlet var daily: UILabel!
    @IBOutlet var monthly: UILabel!
    @IBOutlet var yearly: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        //This is an attempt to update the labels on the coffeeCounts page... 
      
        var user = PFUser.currentUser().username
        println(user)
        
            var query = PFQuery(className:"Post")
            query.whereKey("username", equalTo: user)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    // The find succeeded.
                    println("Successfully retrieved \(objects.count) post.")
                    // Do something with the found objects
                    
                    self.daily.text = String(objects.count)
                    
                    let date = NSDate()
                    println(date)
                    
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            println(object.objectId)
                            
                            
                        }
                    }
                } else {
                    // Log details of the failure
                    println("Error: \(error) \(error.userInfo!)")
                }
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
