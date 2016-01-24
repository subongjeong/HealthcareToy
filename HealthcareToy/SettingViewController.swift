//
//  SettingViewController.swift
//  HealthcareToy
//
//  Created by Subong Jeong on 2015. 12. 28..
//  Copyright © 2015년 Subong Jeong. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var picker = UIPickerView()
    @IBOutlet weak var cateText: UITextField!
    @IBOutlet weak var goalData: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var pickerData: [String] = [String]()
    var nsObj = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        stepper.value = Double(nsObj.integerForKey("goal"))
        print(nsObj.integerForKey("category"))
        
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["Step Counts", "Sleep Times"]
        
        goalData.text = "\(nsObj.integerForKey("goal"))"
        cateText.inputView = picker
        cateText.text = pickerData[nsObj.integerForKey("category")]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stepperAction(sender: AnyObject) {
        nsObj.setInteger(Int(stepper.value), forKey: "goal")
        goalData.text = "\(nsObj.integerForKey("goal"))"
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        nsObj.setInteger(row, forKey: "category")
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nsObj.setInteger(row, forKey: "category")
        cateText.text = pickerData[row]
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
