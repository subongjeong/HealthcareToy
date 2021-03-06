//
//  SignupViewController.swift
//  HealthcareToy
//
//  Created by Subong Jeong on 2015. 12. 27..
//  Copyright © 2015년 Subong Jeong. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBAction func signupTapped(sender: AnyObject) {
        let username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        let confirm_password:NSString = txtConfirmPassword.text!
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            let alertView = UIAlertController(title: "Sign in Failed",message: "Please enter Username and Password", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true) { }
        } else if ( !password.isEqual(confirm_password) ) {
            let alertView = UIAlertController(title: "Sign in Failed",message: "Passwords doesn't Match", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true) { }
        } else {
            do {
                let post:NSString = "login=\(username)&password=\(password)&password_again=\(confirm_password)"
                //                let post:NSString = "username=\(username)&password=\(password)&c_password=\(confirm_password)"
                
                NSLog("PostData: %@",post);
                
                let url:NSURL = NSURL(string:"http://ec2-52-68-243-230.ap-northeast-1.compute.amazonaws.com:9000/join_mobile")!
                //                let url:NSURL = NSURL(string:"http://localhost:9000/join_mobile")!
                
                let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                
                let postLength:NSString = String( postData.length )
                
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                request.HTTPBody = postData
                request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                
                var reponseError: NSError?
                var response: NSURLResponse?
                
                var urlData: NSData?
                do {
                    urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
                } catch let error as NSError {
                    reponseError = error
                    urlData = nil
                }
                
                if ( urlData != nil ) {
                    let res = response as! NSHTTPURLResponse!;
                    
                    NSLog("Response code: %ld", res.statusCode);
                    
                    if (res.statusCode >= 200 && res.statusCode < 300)
                    {
                        let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                        
                        NSLog("Response ==> %@", responseData);
                        
                        //var error: NSError?
                        
                        let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                        
                        
                        let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                        
                        //[jsonData[@"success"] integerValue];
                        
                        NSLog("Success: %ld", success);
                        
                        if(success == 1)
                        {
                            NSLog("Sign Up SUCCESS");
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            var error_msg:NSString
                            
                            if jsonData["error_message"] as? NSString != nil {
                                error_msg = jsonData["error_message"] as! NSString
                            } else {
                                error_msg = "Unknown Error"
                            }
                            
                            let alertView = UIAlertController(title: "Sign in Failed",message: error_msg as String, preferredStyle: .Alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in }
                            alertView.addAction(okAction)
                            self.presentViewController(alertView, animated: true) { }
                        }
                        
                    } else {
                        let alertView = UIAlertController(title: "Sign in Failed",message: "Connection Failed", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in }
                        alertView.addAction(okAction)
                        self.presentViewController(alertView, animated: true) { }
                    }
                }  else {
                    let alertView = UIAlertController(title: "Sign in Failed",message: "Connection Failuer", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in }
                    alertView.addAction(okAction)
                    self.presentViewController(alertView, animated: true) { }                }
            } catch {
                let alertView = UIAlertController(title: "Sign in Failed",message: "Server Error", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in }
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true) { }
            }
        }
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
