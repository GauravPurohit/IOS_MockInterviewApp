//
//  ViewController.swift
//  abcd
//
//  Created by Purohit, Gaurav C on 2/15/16.
//  Copyright © 2016 Purohit, Gaurav C. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation

class VideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    
    
    @IBOutlet weak var PhotoLibrary: UIButton!
    @IBOutlet weak var Camera: UIButton!
    @IBOutlet weak var ImageDisplay: UIImageView!
 
    @IBAction func LogoutButton(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        
       // self.performSegueWithIdentifier("VideoviewToLogin", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   
    @IBAction func SubmitRecording(sender: AnyObject) {
    }
    
    @IBAction func WelcomeButton(sender: AnyObject) {
    }
    
   
    @IBAction func PhotoLibraryAction(sender: UIButton) {
        let picker=UIImagePickerController()
        picker.delegate=self
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
    }
   
    
    @IBAction func Camera(sender: UIButton) {
        let picker=UIImagePickerController()
        picker.delegate=self
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.sourceType = .Camera
        
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        ImageDisplay.image = info[UIImagePickerControllerOriginalImage] as? UIImage;
        //let tempImage = info[UIImagePickerControllerOriginalImage] as? UIImage;
     //   UIImageWriteToSavedPhotosAlbum(tempImage!, self, nil, nil)
        
        let tempImage = info[UIImagePickerControllerMediaURL] as? NSURL!
        let pathString = tempImage!.relativePath
        UISaveVideoAtPathToSavedPhotosAlbum(pathString!, self, nil, nil)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
        
    
}

