//
//  VideoUploadFileViewController.swift
//  abcd
//
//  Created by Purohit, Gaurav C on 2/15/16.
//  Copyright © 2016 Purohit, Gaurav C. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation

class VideoUploadFileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    
    
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
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
        myImageUploadRequest()
    }
    
    @IBAction func WelcomeButton(sender: AnyObject) {
    }
    
    
    @IBAction func PhotoLibraryAction(sender: UIButton) {
        let picker=UIImagePickerController()
        picker.delegate=self
       // picker.mediaTypes = [kUTTypeMovie as String]
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
        
       // let tempImage = info[UIImagePickerControllerMediaURL] as? NSURL!
       // let pathString = tempImage!.relativePath
        
        //UISaveVideoAtPathToSavedPhotosAlbum(pathString!, self, nil, nil)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func myImageUploadRequest()
    {
        
        let myUrl = NSURL(string: "http://gauravpurohit.co.nf/loginRegister/FileServer.php");
        
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let param = [
            "firstName"  : "Gaurav",
            "lastName"    : "Purohit",
            "userId"    : "1"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(ImageDisplay.image!, 1)
        let imageData1 = UIImagePickerControllerMediaURL as? NSData
        
        if(imageData==nil)  { return; }
        
        
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        
        myActivityIndicator.startAnimating();
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("****** response data = \(responseString!)")
            
            var err: NSError?
            do {
                var json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            
            }
            catch {
                // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                print("A JSON parsing error occurred, here are the details:\n \(error)")
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                self.myActivityIndicator.stopAnimating()
                self.ImageDisplay.image = nil;
            });
            
            /*
            if let parseJSON = json {
            var firstNameValue = parseJSON["firstName"] as? String
            println("firstNameValue: \(firstNameValue)")
            }
            */
            
        }
        
        task.resume()
        
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        var body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user_profile.jpg"
        
        let mimetype = "image/jpg"
        //let mimetype = "video/x-msvideo"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

