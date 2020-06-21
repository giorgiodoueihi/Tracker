//
//  AddThoughtViewController.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 5/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

class AddThoughtViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet private var thoughtTextField: UITextField!
    @IBOutlet private var distressSlider: UISlider!
    @IBOutlet private var doneButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureForThoughtTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        thoughtTextField.becomeFirstResponder()
    }
    
    
    // MARK: - Configuring
    
    private func configureForThoughtTextField() {
        doneButton.isEnabled = thoughtTextField.text?.isEmpty == false
        
    }
    
    // MARK: - Actions
    
    @IBAction private func textDidChange() {
        configureForThoughtTextField()
    }
    
    @IBAction private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func done() {
        guard let thought = thoughtTextField.text else { return } // Should never be called, since we check for `.isEmpty`
        _ = Thought(contents: thought, distress: distressSlider.value)
        PersistenceManager.shared.saveIfNecessary()
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
        
        thoughtTextField.resignFirstResponder()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
        
        thoughtTextField.becomeFirstResponder()
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == false {
            done()
        }
        
        return true
    }
    
}
