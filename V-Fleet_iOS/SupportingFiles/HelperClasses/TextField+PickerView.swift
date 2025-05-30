//
//  TextField+PickerView.swift
//  Whetness
//
//  Created by Kamaljeet Punia on 15/04/21.
//  Copyright © 2021 Kamaljeet Punia. All rights reserved.
//

import UIKit

/*class TextFieldHelper: NSObject {
 static var shared = TextFieldHelper()
 var datePicker: UIDatePicker!
 var selectedTextField: UITextField?
 var mode: UIDatePicker.Mode = .date {
 didSet {
 self.datePicker?.datePickerMode = mode
 }
 }
 var didChangeDateCompletion: ((UIDatePicker) -> ())?
 var selectedDateFormat: DateFormat = .monthFirst
 
 override private init() {
 super.init()
 }
 
 func showDatePicker(with textField: UITextField, minimumDate: Date? = nil, maximumDate: Date? = nil, mode: UIDatePicker.Mode = .date) {
 self.selectedDateFormat = mode == .dateAndTime ? .dateTime: .monthFirst
 var currentTime = AppCacheData.sharedInstance.getAccurateTime()
 
 let screenWidth = UIScreen.main.bounds.width
 self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
 self.datePicker.datePickerMode = mode
 self.datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
 if let minDate = minimumDate {
 currentTime = minDate
 self.datePicker.minimumDate = currentTime
 }
 
 if let maxDate = maximumDate {
 self.datePicker.maximumDate = maxDate
 }
 textField.inputView = self.datePicker
 if let text = textField.text, text != "" {
 if let date = Date.dateFromString(text, format: .monthFirst) {
 self.datePicker.setDate(date, animated: false)
 }else if let date = Date.dateFromString(text, format: .dateTime) {
 textField.text = date.getString(format: self.selectedDateFormat)
 self.datePicker.setDate(date, animated: false)
 }
 }else {
 self.datePicker.setDate(currentTime, animated: false)
 textField.text = currentTime.getString(format: self.selectedDateFormat)//format must be same as didChangeDate method's format.
 }
 self.selectedTextField = textField
 }
 
 @objc func didChangeDate(_ picker: UIDatePicker) {
 selectedTextField?.text = picker.date.getString(format: self.selectedDateFormat)
 self.didChangeDateCompletion?(picker)
 }
 }
 */

class TextFieldHelper: NSObject {
    
    // MARK: - VARIABLES
    static let shared = TextFieldHelper()
    private var pickerView: UIPickerView?
    private var pickerViewArray = [String]()
    private var selectedTextField: UITextField?
    private var completion: ((_ index: Int) -> ())?
    
    // MARK: - INITIALIZER
    private override init() {
        super.init()
    }
    
    // MARK: - INTERNAL FUNCTIONS
    func showPicker(textField: UITextField, array: [String], completion: ((_ index: Int) -> ())?) {
        self.selectedTextField = textField
        self.pickerViewArray = array
        self.completion = completion
        self.setupPickerView()
    }
    
}

// MARK: - PICKER VIEW DATA SOURCE
extension TextFieldHelper: UIPickerViewDataSource {
    
    // MARK: - Custom Picker Methods
    private func setupPickerView() {
        self.pickerView = UIPickerView()
        guard let pickerView = self.pickerView else {
            return
        }
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //Set Picker View to Textfield
        self.selectedTextField?.inputView = pickerView
        pickerView.reloadAllComponents()
        self.setDefaultText()
    }
    
    private func setDefaultText() {
        if self.selectedTextField?.text?.isEmptyWithTrimmedSpace ?? true {
            self.selectedTextField?.text = self.pickerViewArray.first
            self.completion?(0)
        }else {
            if let text = self.selectedTextField?.text,
               let index = self.pickerViewArray.firstIndex(where: {$0 == text}) {
                self.pickerView?.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerViewArray.count
    }
    
}

// MARK: - PICKER VIEW DELEGATE
extension TextFieldHelper: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerViewArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerViewArray.count > row {
            self.selectedTextField?.text = self.pickerViewArray[row]
            self.completion?(row)
        }
    }
}

