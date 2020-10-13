//
//  ThoughtInputViewController.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 5/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

class ThoughtInputViewController: UITableViewController, UITextViewDelegate {
    
    @IBOutlet private var thoughtTextView: PlaceholderTextView!
    @IBOutlet private var distressSlider: UISlider!
    @IBOutlet private var doneButton: UIBarButtonItem!

    var thought: Thought?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureForEditingThought()
        configureForThoughtTextField()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        thoughtTextView.resignFirstResponder()
    }
    
    
    // MARK: - Configuring
    
    private func configureForThoughtTextField() {
        doneButton.isEnabled = thoughtTextView.text?.isEmpty == false
        thoughtTextView.becomeFirstResponder()
    }
    
    private func configureForEditingThought() {
        switch thought {
        case .none:
            navigationItem.title = "Add new thought"
            thoughtTextView.becomeFirstResponder()
        case .some(let thought):
            navigationItem.title = "Edit thought"
            thoughtTextView.text = thought.contents
            let value = Float(thought.distress) / 10.0
            distressSlider.setValue(value, animated: false)
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func done() {
        switch thought {
        case .none:
            thought = Thought(contents: thoughtTextView.text, distress: distressSlider.value)
        case .some(let thought):
            thought.contents = thoughtTextView.text
            thought.distress = Int(distressSlider.value * 10)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            thoughtTextView.resignFirstResponder()
        }
    }
    
    
    // MARK: - UITextViewDelegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if CharacterSet.newlines.contains(newString.last) {
            done()
            return false
        } else {
            return true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates() /// Resizes `thoughtTextView` cell
        configureForThoughtTextField()
        tableView.endUpdates()
    }
    
}
