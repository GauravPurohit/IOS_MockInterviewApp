//
//  VideoUploadFileViewController.swift
//  abcd
//
//  Created by Purohit, Gaurav C on 2/15/16.
//  Copyright © 2016 Purohit, Gaurav C. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import MobileCoreServices
import AVFoundation

class VideoUploadFileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate,DownloadManagerProtocol {
    
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var PhotoLibrary: UIButton!
    @IBOutlet weak var Camera: UIButton!
    @IBOutlet weak var ImageDisplay: UIImageView!
    @IBOutlet weak var submitRecording: UIButton!
    @IBOutlet weak var submitTest: UIButton!
    var progressController: ProgressController!
    
    var videoURL:NSURL!
    var RecvUserName:String = ""
    var questioncount = 0;
    var filecount = 1;
    @IBOutlet weak var questionText: UITextView!
    var text = ""
    var questions = ["Tell me about yourself", "Why did you leave your last job", "Why do you want to work here", "What are your strengths", "What are your weaknesses", "What are your goals", "Tell me about a time when you", "What would you do if", "What is your salary requirement", "Do you have any questions for me?"]
    
    let playerController = AVPlayerViewController()
    
    
    
    @IBAction func LogoutButton(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        //self.performSegueWithIdentifier("VideoviewToLogin", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressController = ProgressController()
        progressController.progressBar = self.progressBar
        self.submitRecording.enabled = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        text += "\(questions[questioncount])"
        questionText.text = text
        questionText.font = questionText.font?.fontWithSize(23)
        questioncount++
       
        
    }
    
    @IBAction func submitRecordingTapped(sender: AnyObject) {
        
        self.submitRecording.enabled = false
        
        playerController.player = nil
        playerController.view.removeFromSuperview()
        
        if questioncount<10 {
            text = "\(questions[questioncount])"
            questionText.text = text
            questionText.font = questionText.font?.fontWithSize(20)
            myImageUploadRequest()
            
        }
        
    }
    
    @IBAction func submitTest(sender: AnyObject) {
      // myImageDownloadRequest()
        downloadFile()
    }
    
    
    
    @IBAction func WelcomeButton(sender: AnyObject) {
    }
    
    
    @IBAction func PhotoLibraryAction(sender: UIButton) {
        let picker=UIImagePickerController()
        picker.delegate=self
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func Camera(sender: UIButton) {
        let picker=UIImagePickerController()
        picker.delegate=self
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.sourceType = .Camera
        //picker.showsCameraControls = false
        picker.cameraDevice = UIImagePickerControllerCameraDevice.Front
        
            presentViewController(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
       // ImageDisplay.image = info[UIImagePickerControllerOriginalImage] as? UIImage;
                //let tempImage = info[UIImagePickerControllerOriginalImage] as? UIImage;
        //   UIImageWriteToSavedPhotosAlbum(tempImage!, self, nil, nil)
        let tempImage = info[UIImagePickerControllerMediaURL] as? NSURL!
    
        //NSLog("tempImage= ", tempImage!)
        let pathString = tempImage!.relativePath
        
        UISaveVideoAtPathToSavedPhotosAlbum(pathString!, self, nil, nil)
        
        self.videoURL = info[UIImagePickerControllerMediaURL] as! NSURL;
        
        let player = AVPlayer(URL: videoURL)
        
        playerController.player = player
        playerController.view.frame = CGRectMake(0, 260, self.self.view.frame.size.width, 250)
        //self.presentViewController(playerController, animated: true, completion: nil)
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.didMoveToParentViewController(self)
        player.play()

        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.submitRecording.enabled = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func myImageUploadRequest()
    {
        
        
         let myUrl = NSURL(string: "http://gauravpurohit.co.nf/loginRegister/FileServer.php");
       // let myUrl = NSURL(string: "http://localhost:8888/FileServer.php");
        
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let param = [
            "firstName"  : RecvUserName,
            "lastName"    : "Purohit",
            "userId"    : "1"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        //let imageData = UIImageJPEGRepresentation(ImageDisplay.image!, 1)
        
      //  let tempImage = UIImagePickerControllerMediaType as? UIImage
     //   let pathString = tempImage!.relativePath
       // NSLog("pathString= ", pathString!)
        let videoData = NSData(contentsOfURL: videoURL)
        
        //   { return; }
        
        
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: videoData!, boundary: boundary)
        
        
        
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
                
                
                
                if let parseJSON = json {
                    var resultValue = parseJSON["Status"] as? String
                    print("result\(resultValue)")
                    
                    var messageToDisplay:String = parseJSON["Message"] as! String!
                    
                    var isUserLoggedin:Bool = false;
                    if(resultValue==("OK"))
                    {
                        
                        messageToDisplay = parseJSON["Message"] as! String!
                        dispatch_async(dispatch_get_main_queue(), {
                        self.displayAlertMessage(messageToDisplay)
                            });
                        
                        
                        // self.dismissViewControllerAnimated(true, completion: nil)
                        
                    }
                        
                        
                        
                    else
                    {
                        messageToDisplay = parseJSON["Message"] as! String!
                        dispatch_async(dispatch_get_main_queue(), {
                            self.displayAlertMessage(messageToDisplay)
                        });
                        
                        
                        
                    }
                    
                    
                }
                
                
                
                
                
                
                
            
            }
            catch {
                // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                print("A JSON parsing error occurred, here are the details:\n \(error)")
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                self.myActivityIndicator.stopAnimating()
                //self.ImageDisplay.image = nil;
            });
            
            /*
            if let parseJSON = json {
            var firstNameValue = parseJSON["firstName"] as? String
            println("firstNameValue: \(firstNameValue)")
            }
            */
            
        }
        
        task.resume()
        //self.submitRecording.enabled  = true
        
    }
    
    
    
    func downloadFile()
    {
        
        let url = "https://s3.amazonaws.com/gpuro/try/umesh_1.mp4"
        
        DownloadManager(delegate: self).downloadFileForUrl(url)
        
    }
    
    func downloadedFileAtPath(path: NSURL)
    {
        
        let temp = path.relativePath
        UISaveVideoAtPathToSavedPhotosAlbum(temp!, self, nil, nil)

    }
    
    
    func downloadedMbytesFromTotal(downloaded: Int64, total: Int64)
    {
        progressController.setProgressDownload(downloaded, total: total)
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
    func myImageDownloadRequest()
    {
        
        let myUrl = NSURL(string: "https://s3.amazonaws.com/gpuro/try/umesh_1.mp4")
         let tryUrl = "https://s3.amazonaws.com/gpuro/try/umesh_1.mp4"
        //let myUrl = NSURL(string: "http://gauravpurohit.co.nf/loginRegister/FileServer.php");
        
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let param = [
            "firstName"  : RecvUserName,
            "lastName"    : "Purohit",
            "userId"    : "1"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        //let imageData = UIImageJPEGRepresentation(ImageDisplay.image!, 1)
        
        //  let tempImage = UIImagePickerControllerMediaType as? UIImage
        //   let pathString = tempImage!.relativePath
        // NSLog("pathString= ", pathString!)
       // let videoData = NSData(contentsOfURL: videoURL)
        
        //   { return; }
        
        
        
       // request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: videoData!, boundary: boundary)
        
        
        
        myActivityIndicator.startAnimating();
        
        let download = NSURLSession.sharedSession().downloadTaskWithURL(NSURL(string: tryUrl)!)
        
        let task = NSURLSession.sharedSession().downloadTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
           // let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
        }
        
        task.resume()
        UISaveVideoAtPathToSavedPhotosAlbum(myUrl!.relativePath!, self, nil, nil)
        //self.submitRecording.enabled  = true
        
    }

    
    
    
    
    func displayAlertMessage(userMessage:String)
    {
        var myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction);
        presentViewController(myAlert, animated: true, completion: nil)
        self.submitRecording.enabled  = false
        
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
        
        questioncount++
        let filename = RecvUserName + "_" + "\(filecount)" + ".mp4"
        filecount++
        
        //let mimetype = "image/jpeg"
        let mimetype = "video/mp4"
        
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

