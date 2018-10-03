//
//  SWTableViewController.swift
//  Swift-Example
//
//  Created by Petr Korolev on 19/09/14.
//  Copyright (c) 2014 Petr Korolev. All rights reserved.
//

import UIKit
import CoreActionSheetPicker

class SWTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!


    @IBAction func navigationBarItemPicker(_ sender: UIBarButtonItem) {
        // example of string picker with done and cancel blocks
        ActionSheetStringPicker.show(withTitle: "Picker from navigation bar",
                                     rows: ["One", "Two", "A lot"],
                                     initialSelection: 1,
                                     doneBlock: { picker, value, index in
                                        print("picker = \(String(describing: picker))")
                                        print("value = \(value)")
                                        print("index = \(String(describing: index))")
                                        return
                                     },
                                     cancel: { picker in
                                        return
                                     },
                                     origin: sender)
    }


    @IBAction func localePickerClicked(_ sender: UIButton) {
        // example of date picker initialized with done and cancel blocks (origin in this case is tableview cell whose contentView has UIButton for picker)
        ActionSheetLocalePicker.show(withTitle: "Locale picker",
                                     initialSelection: nil,
                                     doneBlock: { picker, timezone in
                                        print("picker = \(String(describing: picker))")
                                        print("timezone = \(String(describing: timezone))")
                                        return
                                     },
                                     cancel: { picker in
                                        return
                                    },
                                    origin: sender.superview!.superview)
    }


    @IBAction func timePickerClicked(_ sender: UIButton) {
        // example of picker initialized with target/action parameters
        let datePicker = ActionSheetDatePicker(title: "Time:",
                                               datePickerMode: UIDatePickerMode.time,
                                               selectedDate: Date(),
                                               target: self,
                                               action: #selector(datePicked(_:)),
                                               origin: sender.superview!.superview)

        datePicker?.minuteInterval = 20

        datePicker?.show()
    }

    func datePicked(_ date: Date) {
        print("Date picked \(date)")
    }


    @IBAction func datePickerClicked(_ sender: UIButton) {
        // example of date picker with min and max values set (as a week in past and week in future from today)
        let datePicker = ActionSheetDatePicker(title: "Date within 2 weeks:",
                                               datePickerMode: UIDatePickerMode.date,
                                               selectedDate: Date(),
                                               doneBlock: { picker, date, origin in
                                                    print("picker = \(String(describing: picker))")
                                                    print("date = \(String(describing: date))")
                                                    print("origin = \(String(describing: origin))")
                                                    return
                                                },
                                               cancel: { picker in
                                                    return
                                               },
                                               origin: sender.superview!.superview)
        let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;
        datePicker?.minimumDate = Date(timeInterval: -secondsInWeek, since: Date())
        datePicker?.maximumDate = Date(timeInterval: secondsInWeek, since: Date())

        datePicker?.show()
    }


    @IBAction func dateAndTimePickerClicked(_ sender: UIButton) {
        // example od datetime picker with step interval set to 20 min
        let datePicker = ActionSheetDatePicker(title: "DateTime with 20min intervals:",
                                               datePickerMode: UIDatePickerMode.dateAndTime,
                                               selectedDate: Date(),
                                               doneBlock: { picker, date, origin in
                                                    print("picker = \(String(describing: picker))")
                                                    print("date = \(String(describing: date))")
                                                    print("origin = \(String(describing: origin))")
                                                    return
                                                },
                                               cancel: { picker in
                                                return
                                               },
                                               origin: sender.superview!.superview)
        datePicker?.minuteInterval = 20

        datePicker?.show()
    }


    @IBAction func countdownPickerClicked(_ sender: UIButton) {
        // example of countdown time picker with default value set
        let datePicker = ActionSheetDatePicker(title: "CountDownTimer:",
                                               datePickerMode: UIDatePickerMode.countDownTimer,
                                               selectedDate: Date(),
                                               doneBlock: { picker, date, origin in
                                                    print("picker = \(String(describing: picker))")
                                                    print("date = \(String(describing: date))")
                                                    print("origin = \(String(describing: origin))")
                                                    return
                                               },
                                               cancel: { picker in
                                                    return
                                               },
                                               origin: sender)

        datePicker?.countDownDuration = 60 * 7
        datePicker?.show()
    }

    
    @IBAction func distancePickerClicked(_ sender: UIButton) {
        // example of distance picker with target/action selector
        let distancePicker = ActionSheetDistancePicker(title: "Select distance",
                                                       bigUnitString: "m",
                                                       bigUnitMax: 2,
                                                       selectedBigUnit: 1,
                                                       smallUnitString: "cm",
                                                       smallUnitMax: 99,
                                                       selectedSmallUnit: 60,
                                                       target: self,
                                                       action: #selector(measurementWasSelected(_:smallUnit:origin:)),
                                                       origin: sender.superview!.superview)
        distancePicker?.show()
    }

    func measurementWasSelected(_ bigUnit: NSNumber, smallUnit: NSNumber, origin: AnyObject) {
        print("measurementWasSelected")
        print("bigUnits - \(bigUnit)")
        print("smallUnits - \(smallUnit)")
        print("origin - \(origin)")
    }


    @IBAction func multipleStringPickerClicked(_ sender: UIButton) {
        // example of multicolumn string picker with custom colors
        let acp = ActionSheetMultipleStringPicker(title: "Multiple String Picker",
                                                  rows: [ ["One", "Two", "A lot"],
                                                          ["Many", "Many more", "Infinite"] ],
                                                  initialSelection: [2, 2],
                                                  doneBlock: { picker, indexes, values in
                                                        print("indexes = \(String(describing: indexes))")
                                                        print("values = \(String(describing: values))")
                                                        print("picker = \(String(describing: picker))")
                                                        return
                                                    },
                                                  cancel: { picker in
                                                        return
                                                  },
                                                  origin: sender)

        acp?.pickerTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20.0)]
        acp?.setTextColor(UIColor.red)
        acp?.pickerBackgroundColor = UIColor.black
        acp?.toolbarBackgroundColor = UIColor.yellow
        acp?.toolbarButtonsColor = UIColor.white
        acp?.show()
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    @IBAction func hideKeyboard(_ sender: AnyObject) {
        self.textField.becomeFirstResponder()
    }
}
