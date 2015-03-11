//
//  ViewController.swift
//  ImHavingCoffee
//
//  Created by Nicholas Miller on 2/23/15.
//  Copyright (c) 2015 Nicholas Miller. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var loginCancelledLabel: UILabel!
   
    @IBAction func signIn(sender: AnyObject) {
    
        var permissions = ["public_profile", "email", "user_friends"]
        
        self.loginCancelledLabel.alpha = 0
        
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
                
                self.loginCancelledLabel.alpha = 1
                
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
                
                self.performSegueWithIdentifier("signUp", sender: self)
                
            } else {
                NSLog("User logged in through Facebook!")
            
                self.performSegueWithIdentifier("existingUser", sender: self)
                
            }
        })
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.loginCancelledLabel.alpha = 0
        
           /* this is Twitter's Digit Button (USE LATER!!)
            let authenticateButton = DGTAuthenticateButton(authenticationCompletion: {
                (session: DGTSession!, error: NSError!) in
                // play with Digits session
            })
            authenticateButton.center = self.view.center
            self.view.addSubview(authenticateButton)

            */
        
            
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //self.navigationController?navigationBarHidden = true
        
        if PFUser.currentUser() != nil {
            
            println(PFUser.currentUser()["name"])
            
            self.performSegueWithIdentifier("existingUser", sender: self)
            
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        //self.navigationController?navigationBarHidden = false
        
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
