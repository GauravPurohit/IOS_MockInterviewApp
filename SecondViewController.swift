//
//  SecondViewController.swift
//  abcd
//
//  Created by Purohit, Gaurav C on 2/16/16.
//  Copyright © 2016 Purohit, Gaurav C. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var WelcomeTextArea: UITextView!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
  
   
    override func viewWillAppear(animated: Bool)
     {
        
        UITextView.self
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Username.delegate = self;
        self.Password.delegate = self;
        UITextView.self
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func CreateAccount(sender: AnyObject) {
       
    }
    
    @IBAction func LoginButton(sender: AnyObject) {
        
        let userName = Username.text
        let passWord = Password.text
        
        
       // let userNameStored = NSUserDefaults.standardUserDefaults().stringForKey("userName")
      //  let passWordStored = NSUserDefaults.standardUserDefaults().stringForKey("passWord")
        
        if(userName!.isEmpty || passWord!.isEmpty)
        {
            displayAlertMessage("Username and/or Password do not match our records, please try again!");
            return;
        }
        
        //let myUrl = NSURL(string: "http://localhost:8888/UserLogin.php");
        let myUrl = NSURL(string: "http://gauravpurohit.co.nf/loginRegister/UserLoginServer.php");
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = "userName=\(userName!)&passWord=\(passWord!)"
        print (postString)
        
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)!
        print("request: \(request.HTTPBody)")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data,response,error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response: \(response)")
            print("data: \(data!)")
            let string1 = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(string1)
            
            do {
                
                var json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                print("json: \(json)")
                
                if let parseJSON = json {
                    var resultValue = parseJSON["status"] as? String
                    print("result\(resultValue)")
                    
                    var messageToDisplay:String = parseJSON["message"] as! String!
                    
                 var isUserLoggedin:Bool = false;
                    if(resultValue==("Success"))
                    {
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                        NSUserDefaults.standardUserDefaults().synchronize()
                       // self.dismissViewControllerAnimated(true, completion: nil)
                        isUserLoggedin = true
                    
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            
                       self.performSegueWithIdentifier("LoggedInCandidateToInterview", sender: nil)
                         
                        } 
                        
                    }
                    
                    
                    
                    else
                    {
                        messageToDisplay = parseJSON["message"] as! String!
                        dispatch_async(dispatch_get_main_queue(), {
                        self.displayAlertMessage(messageToDisplay)
                        });
                        
                        return;
                        
                    }
                    
                    
                }
                
            }
            catch {
                print("A JSON parsing error occurred, here are the details:\n \(error)")
            }
        }
        task.resume()
        
    }
    

    
    
    
    func displayAlertMessage(userMessage:String)
    {
        var myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction);
        presentViewController(myAlert, animated: true, completion: nil)
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "LoggedInCandidateToInterview") {
        let VideoVC: SecViewController = segue.destinationViewController as! SecViewController
        VideoVC.RecvUserName = Username.text!
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return false
    }
    
    
}
