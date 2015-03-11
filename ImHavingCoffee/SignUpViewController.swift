//
//  SignUpViewController.swift
//  ImHavingCoffee
//
//  Created by Nicholas Miller on 2/23/15.
//  Copyright (c) 2015 Nicholas Miller. All rights reserved.
//

import UIKit
import TwitterKit


class SignUpViewController: UIViewController {

    @IBOutlet var profilePic: UIImageView!
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var userName: UITextField!
    
    
    @IBAction func signUp(sender: AnyObject) {
        
        var user = PFUser.currentUser()
        
        self.phone.text = self.phone.text.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)

        user["first_name"] = self.firstName.text as String
        user["last_name"] = self.lastName.text as String
        user["email"] = self.email.text as String
        user["phone"] = self.phone.text as String
        user["ihc_username"] = self.userName.text as String
        
        
        user.save()
        
        println("signed up")
        
        self.performSegueWithIdentifier("signUp", sender: self)
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var user = PFUser.currentUser()
        
        //grab users current location
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            
            if error != nil {
                
                user["location"] = geopoint
                
                user.save()
                
                println(geopoint)
                
            }
        }
        
        //grab the user photo from facebook's graph.
        
        var FBSession = PFFacebookUtils.session()
        
        var accessToken = FBSession.accessTokenData.accessToken
        
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
        
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            let image = UIImage(data: data)
            
            self.profilePic.image = image
            
            user["image"] = data
            user.save()
            
            FBRequestConnection.startForMeWithCompletionHandler({
                connection, result, error in
                
            println(result)

            
            self.firstName.text = result["first_name"] as String
            self.lastName.text = result["last_name"] as String
            self.email.text = result["email"] as String
            //self.location.text = geopoint.
            user["gender"] = result["gender"]
            user["name"] = result["name"]
            user["fb_id"] = result["id"]
            user["fb_link"] = result["link"]
                
            })
            user.save()
            
        })
    
        }
    
    /*
    override func viewDidAppear(animated: Bool) {
    if PFUser.currentUser() != nil {
    println("this is where you segue")
    
    }
    } */
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
