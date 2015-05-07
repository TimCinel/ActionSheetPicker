//
//  SwiftViewController.swift
//  CocoaPods-example
//
//  Created by Petr Korolev on 04/05/15.
//  Copyright (c) 2015 Petr Korolev. All rights reserved.
//

import UIKit

class SwiftViewController: UIViewController {

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

    @IBAction func btnClicked(sender: AnyObject) {
        ActionSheetLocalePicker.showPickerWithTitle("Locale picker", initialSelection: NSTimeZone(), doneBlock: {
            picker, index in
            
            println("index = \(index)")
            println("picker = \(picker)")
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender.superview!)
    }
}
