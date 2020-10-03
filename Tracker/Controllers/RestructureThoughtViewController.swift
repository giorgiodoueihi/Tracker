//
//  RestructureThoughtViewController.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 21/9/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

class RestructureThoughtViewController: UITableViewController, UITextViewDelegate {
    
    @IBOutlet private var textView: PlaceholderTextView!
    @IBOutlet private var nextButton: UIBarButtonItem!
    @IBOutlet private var prompt: UILabel!
    
    var challenge: CognitiveChallenge? {
        didSet {
            let currentIndex = challenge?.currentIndex ?? 0
            navigationItem.title = "Question \(currentIndex + 1) of \(CognitiveChallenge.allCases.count)"
            if currentIndex == 0 {
                let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
                navigationItem.leftBarButtonItem = cancelButton
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                        
        setupBarButtonItems()
        configurePrompt()
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
    
    
    // MARK: - Setup
    
    private func setupBarButtonItems() {
        nextButton.title = isLastChallenge ? "Done" : "Next"
        nextButton.style = isLastChallenge ? .done : .plain
        nextButton.isEnabled = false
    }
    
    
    // MARK: - Configuring
    
    private func configureNextButton() {
        nextButton.isEnabled = !textView.text.isEmpty
    }
    
    private func configurePrompt() {
        prompt.text = [challenge?.question, restructuredThought?.thought.contents]
            .compactMap({ $0 })
            .joined(separator: "\n\n")
    }
    
    
    // MARK: - Actions
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView == tableView else {
            return
        }

        textView.resignFirstResponder()
    }
    
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates() /// Resizes `thoughtTextView` cell
        configureNextButton()
        tableView.endUpdates()
    }
    
    
    // MARK: - Helpers
    
    var restructuredThought: RestructuredThought? {
        return (navigationController as? RestructureThoughtNavigationController)?.restructuredThought
    }
    
    var isLastChallenge: Bool {
        return challenge?.nextChallenge == nil
    }
    
}
