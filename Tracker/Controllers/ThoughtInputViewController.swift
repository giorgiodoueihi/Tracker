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
        doneButton.isEnabled = thoughtTextView.text?.isEmpty == false
    }
    
    private func configureForEditingThought() {
        switch editingThought {
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
        guard let textFieldContents = thoughtTextView.text else { /// Should never be called, since we check for `.isEmpty`
            return
        }
        
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
        guard scrollView == tableView else {
            return
        }

        thoughtTextView.resignFirstResponder()
    }
    
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates() /// Resizes `thoughtTextView` cell
        configureForThoughtTextField()
        tableView.endUpdates()
    }
    
}
