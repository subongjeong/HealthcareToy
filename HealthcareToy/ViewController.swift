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
    var goal : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 화면이 표시될 때마다 호출되는 메소드
    override func viewWillAppear(animated: Bool) {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            //            self.usernameLabel.text = prefs.valueForKey("USERNAME") as? String
        }
        
        
        //헬스킷 부분
        let healthStore = HKHealthStore()
        
        if let stepsCount = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount){
            //권한을 얻는 부분
            let dataTypesToWrite = Set<HKSampleType>(arrayLiteral: stepsCount)
            let dataTypesToRead = Set<HKSampleType>(arrayLiteral: stepsCount)
            
            healthStore.requestAuthorizationToShareTypes(dataTypesToWrite, readTypes: dataTypesToRead, completion: {(success,error) ->Void in})
            
            //총합
            var endDate = NSDate()
            endDate = endDate.dateByAddingTimeInterval(60*60*9)
            
            let startDate = endDate.dateByAddingTimeInterval(-60*(60*24*1 + Double(7))) // 현재 날짜부터 7일전. 초단위로 계산이 되어 있다.
            
            let predicate = HKQuery.predicateForSamplesWithStartDate(startDate,endDate: endDate ,options: .None)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
            
            let query = HKSampleQuery(sampleType: stepsCount, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (query, results, error) in
                
                if error != nil {
                    return
                }
                
                var dailyAVG : Double = 0
                for steps in results as! [HKQuantitySample]
                {
                    dailyAVG += steps.quantity.doubleValueForUnit(HKUnit.countUnit())
                }
                let step = dailyAVG
                
                self.healthData = ["Today","Have to"]
                self.goal = Double(self.nsMainObj.integerForKey("goal"))
                let unitsSold = [step,self.goal!-step]
                self.setChart(self.healthData, values: unitsSold)
            }
            healthStore.executeQuery(query)
        }
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutTapped(sender: UIButton) {

        nsMainObj.setInteger(0, forKey: "ISLOGGEDIN")
        //        Double(nsMainObj.integerForKey("goal"))
        
        // let appDomain = NSBundle.mainBundle().bundleIdentifier
        //   NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
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
        
        for _ in 0..<dataPoints.count {
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

