//
//  ThoughtInputViewController.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 5/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

class ThoughtInputViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet private var thoughtTextField: UITextField!
    @IBOutlet private var distressSlider: UISlider!
    @IBOutlet private var doneButton: UIBarButtonItem!

    /// The thought that is currently being edited
    ///
    /// If this variable is `nil`, then we are creating a new `Thought`.
    
    var editingThought: Thought?

        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureForEditingThought()
        configureForThoughtTextField()
    }
    
    
    // MARK: - Configuring
    
    private func configureForThoughtTextField() {
        doneButton.isEnabled = thoughtTextField.text?.isEmpty == false
    }
    
    private func configureForEditingThought() {
        switch editingThought {
        case .none:
            navigationItem.title = "Add new thought"
            thoughtTextField.becomeFirstResponder()
        case .some(let thought):
            navigationItem.title = "Edit thought"
            thoughtTextField.text = thought.contents
            let value = Float(thought.distress) / 10.0
            distressSlider.setValue(value, animated: false)
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction private func textDidChange() {
        configureForThoughtTextField()
    }
    
    @IBAction private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func done() {
        guard let textFieldContents = thoughtTextField.text else { return } // Should never be called, since we check for `.isEmpty`
        
        switch editingThought {
        case .none:
            _ = Thought(contents: textFieldContents, distress: distressSlider.value)
        case .some(let thought):
            thought.contents = textFieldContents
            thought.distress = Int(distressSlider.value * 10)
        }
        
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
