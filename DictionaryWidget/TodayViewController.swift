//
//  TodayViewController.swift
//  DictionaryWidget
//
//  Created by Sherlock Zhong on 1/10/15.
//  Copyright (c) 2015 SherlockZhong. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var launchBtn: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.launchBtn.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
        
    }
    
    @IBAction func launchAction(sender: UIButton) {
        let url : NSURL = NSURL(string: "Dictionary://")!
        self.extensionContext!.openURL(url, completionHandler: nil)
    }
    
}
