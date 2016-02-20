//
//  ViewController.swift
//  VideoRecord1
//
//  Created by Raj Bala on 9/17/14.
//  Copyright (c) 2014 Raj Bala. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation


class TryVideoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    
    override func viewDidAppear(animated: Bool) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            
            print("captureVideoPressed and camera available.")
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = true
            
            imagePicker.showsCameraControls = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
             if imagePicker.isBeingPresented() || imagePicker.isViewLoaded()
             {
                self.dismissViewControllerAnimated(true, completion: {})
                imagePicker.dismissViewControllerAnimated(true, completion: {})

                
                let next = storyboard?.instantiateViewControllerWithIdentifier("FinishController") as! FinishController
                presentViewController(next, animated: true, completion: {})
            }
        }
            
        else {
            print("Camera not available.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let tempImage = info[UIImagePickerControllerMediaURL] as? NSURL!
        let pathString = tempImage!.relativePath
        
        UISaveVideoAtPathToSavedPhotosAlbum(pathString!, self, nil, nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("Image picker has been cancelled")
        picker.dismissViewControllerAnimated(true, completion: {})
        
        
       
        
    }
    
    
    
}
