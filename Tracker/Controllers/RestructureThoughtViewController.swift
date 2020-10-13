//
//  RestructureThoughtViewController.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 21/9/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

class RestructureThoughtViewController: UITableViewController, UITextViewDelegate, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet private var textView: PlaceholderTextView!
    @IBOutlet private var cancelButton: UIBarButtonItem!
    @IBOutlet private var nextButton: UIBarButtonItem!
    @IBOutlet private var prompt: UILabel!
    
    var restructuredThought: RestructuredThought!
    var challenge: CognitiveChallenge? {
        didSet {
            configureForChallenge()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtonItems()
        configurePrompt()
        configurePrefilledTextField()
        configureNextButton()
        navigationController?.presentationController?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        textView.returnKeyType = isLastChallenge ? .done : .next
    }
    
    
    // MARK: - Configuring
    
    private func configureForChallenge() {
        let currentIndex = challenge?.currentIndex ?? 0
        navigationItem.title = "Question \(currentIndex + 1) of \(CognitiveChallenge.allCases.count)"
        if challenge != CognitiveChallenge.allCases.first {
            navigationItem.leftBarButtonItem = nil
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
    
    @IBAction private func next() {
        restructuredThought?.record(answer: textView.text, to: challenge)
        switch isLastChallenge {
        case true:
            dismiss(animated: true, completion: nil)
        case false:
            let controller = UIStoryboard.instantiate(RestructureThoughtViewController.self)
            controller.challenge = challenge?.nextChallenge
            controller.restructuredThought = restructuredThought
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction private func cancel() {
        deleteRestructuredThoughtIfNecessary()
        dismiss(animated: true, completion: nil)
    }
    
    private func deleteRestructuredThoughtIfNecessary() {
        if restructuredThought?.answer(to: CognitiveChallenge.allCases.first) == nil {
            PersistenceManager.shared.delete(restructuredThought)
        }
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            textView.resignFirstResponder()
        }
    }
    
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates() /// Resizes `thoughtTextView` cell
        configureNextButton()
        tableView.endUpdates()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if CharacterSet.newlines.contains(newString.last) {
            next()
            return false
        } else {
            return true
        }
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        deleteRestructuredThoughtIfNecessary()
    }
    
    
    // MARK: - Helpers
    
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
