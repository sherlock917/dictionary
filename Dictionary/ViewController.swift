//
//  ViewController.swift
//  Dictionary
//
//  Created by Sherlock Zhong on 12/19/14.
//  Copyright (c) 2014 SherlockZhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    @IBOutlet var tf_input: UITextField!
    @IBOutlet var tv_history: UITableView!
    @IBOutlet var lb_historyTitle: UILabel!
    
    var history = NSMutableArray()
    let maxHistoryCount = 20
    let historyCellIdentifier = "historyCell"
    let historyFileName = "history.plist"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tf_input.delegate = self
        self.tf_input.becomeFirstResponder()
        
        initHistory()
        self.tv_history.delegate = self
        self.tv_history.dataSource = self
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: "showClearAlert:")
        self.lb_historyTitle.userInteractionEnabled = true
        self.lb_historyTitle.addGestureRecognizer(recognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        search(self.tf_input.text)
        addHistory()
        self.tf_input.text = ""
        return false
    }
    
    @IBAction func touchRightBtn(sender: AnyObject) {
        self.toggleKeyboard()
    }
    
    @IBAction func touchLeftBtn(sender: AnyObject) {
        self.toggleKeyboard()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.tf_input.resignFirstResponder()
    }
    
    func toggleKeyboard() {
        if self.tf_input.isFirstResponder() {
            self.tf_input.resignFirstResponder()
        } else {
            self.tf_input.becomeFirstResponder()
        }
    }
    
    func search(word : String) {
        if UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(word) {
            self.navigationController?.pushViewController(UIReferenceLibraryViewController(term: word), animated: true)
        }
    }
    
    func initHistory() {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(getHistoryPath()) {
            self.history = NSMutableArray(contentsOfFile: getHistoryPath())!
        }
    }
    
    func updateHistory() {
        self.tv_history.reloadData()
    }
    
    func addHistory() {
        self.history.addObject(self.tf_input.text)
        if self.history.count > self.maxHistoryCount {
            self.history.removeObjectAtIndex(0)
        }
        saveHistory()
        updateHistory()
    }
    
    func removeHistory(indexPath: NSIndexPath) {
        self.history.removeObjectAtIndex(self.history.count - 1 - indexPath.row)
        self.tv_history.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        saveHistory()
    }
    
    func clearHistory() {
        self.history.removeAllObjects()
        saveHistory()
        updateHistory()
    }
    
    func saveHistory() {
        self.history.writeToFile(getHistoryPath(), atomically: true)
    }
    
    func showClearAlert(guesture: UILongPressGestureRecognizer) {
        if (guesture.state == UIGestureRecognizerState.Began) {
            let alertView = UIAlertView(title: "NOTICE", message: "\nThis action will clear all saved history, are you sure?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
            alertView.show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 1) {
            clearHistory()
        }
    }
    
    func getHistoryPath() -> String {
        let historyPath : String! = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as? String
        return historyPath.stringByAppendingPathComponent(self.historyFileName)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.history.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tv_history.dequeueReusableCellWithIdentifier(self.historyCellIdentifier) as! UITableViewCell
        cell.textLabel?.text = self.history[self.history.count - indexPath.row - 1] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        search(self.tv_history.cellForRowAtIndexPath(indexPath)!.textLabel!.text!)
        self.tv_history.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            removeHistory(indexPath)
        }
    }
    
}

