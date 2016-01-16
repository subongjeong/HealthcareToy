//
//  LoginViewController.swift
//  HealthcareToy
//
//  Created by Subong Jeong on 2015. 12. 27..
//  Copyright © 2015년 Subong Jeong. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    //로그인시 입력하는 텍스트 필드
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //로그인 버튼을 눌렀을 때
    @IBAction func loginTapped(sender: UIButton) {
        //username과 password에 텍스트 필드에 담긴 내용을 넣는다.
        let username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        
        //텍스트 필드 중 하나라도 값이 없으면 경고문을 띄운다.
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            let alertView = UIAlertController(title: "Sign in Failed",message: "Please enter Username and Password", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true) { }
        } else {
            //그게 아니라면 실행해야지. 서버에 Post 요청을 한다. do를 한 기억이 없는데 되어 있네. 자동인가?
            do {
                let post:NSString = "login=\(username)&password=\(password)&type=\(0)&state=\(0)"
                
                NSLog("PostData: %@",post);
                
                let url:NSURL = NSURL(string:"http://ec2-52-68-243-230.ap-northeast-1.compute.amazonaws.com:9000/login_mobile")!
                
                //let url:NSURL = NSURL(string:"http://localhost:9000/login_mobile")!
                
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
                
                //여기서부터는 아마도 서버에서 값을 받아오는 부분일 것이다.
                if ( urlData != nil ) {
                    let res = response as! NSHTTPURLResponse!;
                    
                    NSLog("Response code: %ld", res.statusCode);
                    
                    //응답이 성공하면
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
                            NSLog("Login SUCCESS");
                            
                            //로그인 값을 저장해둔다.
                            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            prefs.setObject(username, forKey: "USERNAME")
                            prefs.setInteger(1, forKey: "ISLOGGEDIN")
                            prefs.synchronize()
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            var error_msg:NSString
                            
                            if jsonData["error_message"] as? NSString != nil {
                                error_msg = jsonData["error_message"] as! NSString
                            } else {
                                error_msg = "Unknown Error"
                            }
                            let alertView = UIAlertController(
                                title: "Sign in Failed",
                                message: error_msg as String,
                                preferredStyle: .Alert)
                            
                            let okAction = UIAlertAction(
                                title: "OK",
                                style: UIAlertActionStyle.Default) {
                                    action in
                            }
                            alertView.addAction(okAction)
                            self.presentViewController(alertView, animated: true) {
                            }
                        }
                        
                    } else {
                        let alertView = UIAlertController(
                            title: "Sign in Failed",
                            message: "Connection Failure",
                            preferredStyle: .Alert)
                        
                        let okAction = UIAlertAction(
                            title: "OK",
                            style: UIAlertActionStyle.Default) {
                                action in
                        }
                        alertView.addAction(okAction)
                        self.presentViewController(alertView, animated: true) {
                        }
                    }
                } else {
                    let alertView = UIAlertController(
                        title: "Sign in Failed",
                        message: "Connection Failure",
                        preferredStyle: .Alert)
                    
                    let okAction = UIAlertAction(
                        title: "OK",
                        style: UIAlertActionStyle.Default) {
                            action in
                    }
                    alertView.addAction(okAction)
                    self.presentViewController(alertView, animated: true) {
                    }
                }
            } catch {
                let alertView = UIAlertController(
                    title: "Sign in Failed",
                    message: "Server Error",
                    preferredStyle: .Alert)
                
                let okAction = UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.Default) {
                        action in
                }
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true) {
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gif
        //        let filePath = NSBundle.mainBundle().pathForResource("wave", ofType: "gif")
        //        let gif = NSData(contentsOfFile: filePath!)
        //
        //        let webViewBG = UIWebView(frame: self.view.frame)
        //        webViewBG.loadData(gif!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
        //        webViewBG.userInteractionEnabled = false;
        //        self.view.addSubview(webViewBG)
        //
        //        let filter = UIView()
        //        filter.frame = self.view.frame
        //        filter.backgroundColor = UIColor.blackColor()
        //        filter.alpha = 0.05
        //        self.view.addSubview(filter)
        
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
