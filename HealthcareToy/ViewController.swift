//
//  ViewController.swift
//  HealthcareToy
//
//  Created by Subong Jeong on 2015. 12. 27..
//  Copyright © 2015년 Subong Jeong. All rights reserved.
//

import UIKit
import HealthKit
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var pieChart: PieChartView!
    var healthData : [String]!
    var nsMainObj = NSUserDefaults.standardUserDefaults()
    //    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        healthData = ["Today","Have to"]
        let step = 2000.0;
        let goal = Double(nsMainObj.integerForKey("goal"))

        super.viewDidLoad()
        
        let unitsSold = [step,goal-step]
        setChart(healthData, values: unitsSold)
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
        Double(nsMainObj.integerForKey("goal"))
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    
    func setChart(dataPoints : [String], values:[Double]){
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChart.noDataText = "No data"
        pieChart.descriptionText = ""
        pieChart.data = pieChartData
        pieChart.animate(xAxisDuration: 2.0, easingOption: .EaseOutExpo)
        
        var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        
        //        let ll = ChartLimitLine(limit: 10.0, label: "Target")
        //        pieChart.rightAxis.addLimitLine(ll)
    }
}

