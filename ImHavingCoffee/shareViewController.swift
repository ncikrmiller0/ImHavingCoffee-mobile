//
//  shareViewController.swift
//  ImHavingCoffee
//
//  Created by Nicholas Miller on 3/1/15.
//  Copyright (c) 2015 Nicholas Miller. All rights reserved.
//

import UIKit

class shareViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    var name = ""
    var photoSelected:Bool = false
    
    @IBOutlet var imageToPost: UIImageView!
    
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)

        
    }
    
    @IBOutlet var shareText: UITextField!
    

    @IBAction func shareImage(sender: AnyObject) {
        
        var error = ""
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            
            if error != nil {
                
                var user = PFUser.currentUser()
                
                user["location"] = geopoint
                
                user.save()
                
                println(geopoint)
                
            }
            
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem()
            
        }
        
        if photoSelected == false {
            
            error = "please select an image to post"
            
        } else if (shareText.text == "") {
            
            error = "please enter a message"
            
        }
        
        if (error != "") {
            
             displayAlert("Error In Form", error: error)
            
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var post = PFObject(className: "Post")
            post["Title"] = shareText.text
            post["username"] = PFUser.currentUser().username
            //post["location"] = PFUser.currentUser().geoPoint

            
            
            post.saveInBackgroundWithBlock{(success: Bool!, error: NSError!) -> Void in

                if success == false {
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                self.displayAlert("Could Not Post Image", error: "Please try again later")
                
            } else {
                
                let imageData = UIImagePNGRepresentation(self.imageToPost.image)
                
                let imageFile = PFFile(name: "image.png", data: imageData)
                
                post["imageFile"] = imageFile
                
                post.saveInBackgroundWithBlock{(success: Bool!, error: NSError!) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if success == false {
                        
                        self.displayAlert("Could Not Post Image", error: "Please try again later")
                        
                    } else {
                        
                        self.displayAlert("Image Posted!", error: "Your image has been posted successfully")
                        
                        // Update - replaced 0 with false
                        
                        self.photoSelected = false
                        
                        self.imageToPost.image = UIImage(named: "image-share.png")
                        
                        self.shareText.text = ""
                        
                        println("posted successfully")
                        
                    }
                    
                }
                }
                
                
            }
            
            
            
        }
        
        
    }
            
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("Image selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        
        photoSelected = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    photoSelected = false
        
    imageToPost.image = UIImage(named: "image-share.png")
        
    self.navigationController?.toolbarHidden = true 
        
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
