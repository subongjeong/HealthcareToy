//
//  SettingViewController.swift
//  HealthcareToy
//
//  Created by Subong Jeong on 2015. 12. 28..
//  Copyright © 2015년 Subong Jeong. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var goalData: UILabel!
    @IBOutlet weak var dataSelect: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    var pickerData: [String] = [String]()
    
    @IBAction func stepperAction(sender: AnyObject) {
        goalData.text = "\(Int(stepper.value))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["Step Counts", "Sleep Times"]
        
        goalData.text = "\(Int(stepper.value))"
        dataSelect.text = pickerData[0]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dataSelect.text = pickerData[row]
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
