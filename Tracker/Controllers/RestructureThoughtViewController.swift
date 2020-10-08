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
            configureForChallenge()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtonItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurePrompt()
        configurePrefilledTextField()
        configureNextButton()
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        PersistenceManager.shared.saveIfNecessary()
        textView.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.segueIdentifier == .restructureThought {
            restructuredThought?.record(answer: textView.text, to: challenge)
        }
    }
    
    
    // MARK: - Setup
    
    private func setupBarButtonItems() {
        nextButton.title = isLastChallenge ? "Done" : "Next"
        nextButton.style = isLastChallenge ? .done : .plain
        nextButton.isEnabled = false
    }
    
    
    // MARK: - Configuring
    
    private func configureForChallenge() {
        let currentIndex = challenge?.currentIndex ?? 0
        navigationItem.title = "Question \(currentIndex + 1) of \(CognitiveChallenge.allCases.count)"
        if currentIndex == 0 {
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
            navigationItem.leftBarButtonItem = cancelButton
        }
    }
    
    private func configureNextButton() {
        nextButton.isEnabled = !textView.text.isEmpty
    }
    
    private func configurePrompt() {
        let question = challenge?.question ?? ""
        let attributedString = NSMutableAttributedString(string: question + "\n\n")
        attributedString.append(originalThoughtAsItalicisedString)
        prompt.attributedText = attributedString
    }
    
    private func configurePrefilledTextField() {
        textView.text = restructuredThought?.answer(to: challenge)
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
    
    var originalThoughtAsItalicisedString: NSAttributedString {
        let fontDescriptor = prompt.font.fontDescriptor
        var fontTraits = fontDescriptor.symbolicTraits
        fontTraits.update(with: .traitItalic)
        let italicisedFont = UIFont(descriptor: fontDescriptor.withSymbolicTraits(fontTraits)!, size: prompt.font.pointSize)
        let thoughtContents = "“\(restructuredThought?.thought.contents ?? "")”"
        let attributes = [NSAttributedString.Key.font: italicisedFont]
        return NSAttributedString(string: thoughtContents, attributes: attributes)
    }
    
}
