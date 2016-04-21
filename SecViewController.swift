//
//  SecViewController.swift
//  abcd
//
//  Created by Purohit, Gaurav C on 4/20/16.
//  Copyright © 2016 Purohit, Gaurav C. All rights reserved.
//

import UIKit
import SafariServices

class SecViewController: UIViewController,SFSafariViewControllerDelegate {
    
    var RecvUserName:String = ""
    var urlString:String = "https://s3.amazonaws.com/gpuro/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func goToInterviewSession(sender: AnyObject) {
        self.performSegueWithIdentifier("LoggedInCandidateToVideoView", sender: nil)
    }
    
    @available(iOS 9.0, *)
    @IBAction func feedBack(sender: AnyObject) {
        urlString=urlString+RecvUserName+"/feedback/input001.txt"
        let svc = SFSafariViewController(URL: NSURL(string: self.urlString)!,entersReaderIfAvailable: true)
        svc.delegate = self
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func LogoutButton(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "LoggedInCandidateToVideoView") {
            let VideoVC: VideoUploadFileViewController = segue.destinationViewController as! VideoUploadFileViewController
            VideoVC.RecvUserName = RecvUserName
        }
    }
    
    
}


