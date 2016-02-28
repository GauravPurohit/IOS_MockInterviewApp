//
//  FourthViewController.swift
//  abcd
//
//  Created by Purohit, Gaurav C on 2/16/16.
//  Copyright © 2016 Purohit, Gaurav C. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    var pickerDataSource = ["(Select)","Student", "Coach"];
    @IBOutlet weak var UIPickerTextField: UITextField!
    @IBOutlet weak var WelcomeTextArea: UITextView!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var RePassword: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
   // @IBAction func SignInButton(sender: AnyObject) {
      //  let next = self.storyboard?.instantiateViewControllerWithIdentifier("VideoViewController") as! VideoViewController
    //    self.presentViewController(next, animated: true, completion: nil)
  //          }
    
    
    @IBAction func SignInButton(sender: UIButton) {
    }
    
    @IBAction func RegisterButton(sender: UIButton) {
        let userName = Username.text;
        let passWord = Password.text;
        let repeatPassword = RePassword.text;
        
        if(userName!.isEmpty || passWord!.isEmpty || repeatPassword!.isEmpty)
        {
            displayAlertMessage("All fields are required");
            return;
        }
        
        if(passWord != repeatPassword)
        {
            displayAlertMessage("Password do not match");
            return;
        }
      
     //
     //   NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "userName")
     //   NSUserDefaults.standardUserDefaults().setObject(passWord, forKey: "passWord")
     //   NSUserDefaults.standardUserDefaults().synchronize()
        
        //let myUrl = NSURL(string: "http://localhost:8888/userRegister.php");
        let myUrl = NSURL(string: "http://gauravpurohit.co.nf/loginRegister/UserRegisterServer.php");
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = "userName=\(userName!)&passWord=\(passWord!)"
       // let postString = "{\"userName\":\"g\",\"passWord\":\"g\"}"
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
                
                var isUserRegistered:Bool = false;
                if(resultValue=="Success") {isUserRegistered = true}
                
                var messageToDisplay:String = parseJSON["message"] as! String!
                
                if(resultValue=="error")
                {
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                    messageToDisplay = parseJSON["message"] as! String!
                    self.displayAlertMessage(messageToDisplay)
                    }
                    
                   
                        
                }
                else
                {
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.displayAlertMessage(messageToDisplay)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                    self.displayAlertMessage(messageToDisplay)
                    self.performSegueWithIdentifier("RegisteredCandidateToLogin", sender: nil)
                    
                         });
                
                }
                
                
                
                
                
            }
            }
            catch {
                // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        pickerView.hidden=false
        UIPickerTextField.text = pickerDataSource[0]
       
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UIPickerTextField.text = pickerDataSource[row]
        pickerView.hidden=true
        
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        pickerView.hidden = true
        return true
    }
       
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}