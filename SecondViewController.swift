//
//  SecondViewController.swift
//  abcd
//
//  Created by Purohit, Gaurav C on 2/16/16.
//  Copyright © 2016 Purohit, Gaurav C. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    
    
    @IBOutlet weak var WelcomeTextArea: UITextView!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITextView.self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func CreateAccount(sender: AnyObject) {
       
    }
    
    @IBAction func LoginButton(sender: AnyObject) {
        
        let userName = Username.text
        let passWord = Password.text
        
        let userNameStored = NSUserDefaults.standardUserDefaults().stringForKey("userName")
        
        let passWordStored = NSUserDefaults.standardUserDefaults().stringForKey("passWord")
        
        if(userNameStored==userName)
        {
            if(passWordStored==passWord)
            {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
                
            else
            {
                displayAlertMessage("Login and/or Password combination do not match our records, please try again");
                return;
            }
        }
        else
        {
            displayAlertMessage("Login and/or Password combination do not match our records, please try again");
            return;
        }

    }
    

    
    
    
    func displayAlertMessage(userMessage:String)
    {
        var myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction);
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
