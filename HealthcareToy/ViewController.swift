//
//  ViewController.swift
//  HealthcareToy
//
//  Created by Subong Jeong on 2015. 12. 27..
//  Copyright © 2015년 Subong Jeong. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  navigationController?.hidesBarsOnTap = true
        
        let healthStore = HKHealthStore()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            //            self.usernameLabel.text = prefs.valueForKey("USERNAME") as? String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutTapped(sender: UIButton) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}

