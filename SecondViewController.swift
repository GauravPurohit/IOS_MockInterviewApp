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

    @IBAction func CandidateLoginButton(sender: AnyObject) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
