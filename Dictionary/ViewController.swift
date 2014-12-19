//
//  ViewController.swift
//  Dictionary
//
//  Created by Sherlock Zhong on 12/19/14.
//  Copyright (c) 2014 SherlockZhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var tf_input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.tf_input.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        search()
        self.tf_input.text = ""
        return false
    }
    
    func hideKeyboard() {
        tf_input.resignFirstResponder()
    }
    
    func search() {
        if (UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(self.tf_input.text)) {
            var dict = UIReferenceLibraryViewController(term: self.tf_input.text)
            self.navigationController?.pushViewController(dict, animated: true)
        }
    }
    
}

