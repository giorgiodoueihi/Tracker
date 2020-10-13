//
//  ThoughtDetailViewController.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 8/10/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit
import CoreData
import Combine

class ThoughtDetailViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var thought: Thought!
    var thoughtPublisher: Cancellable?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupPublisher()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let navigationController = segue.destination(as: UINavigationController.self)
        if segue.segueIdentifier == .restructureThought {
            let restructureThoughtViewController = navigationController.topViewController as? RestructureThoughtViewController
            restructureThoughtViewController?.restructuredThought = thought?.restructuredThought ?? RestructuredThought(thought)
            restructureThoughtViewController?.challenge = CognitiveChallenge.allCases.first
        } else if segue.segueIdentifier == .editThought {
            let thoughtInputViewController = navigationController.topViewController as? ThoughtInputViewController
            thoughtInputViewController?.thought = thought
        }
    }
    
    
    // MARK: - Setup
    
    private func setupTableView() {
        let thoughtCellNibName = "ThoughtCell"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ActionCell")
        tableView.register(UINib(nibName: thoughtCellNibName, bundle: nil), forCellReuseIdentifier: thoughtCellNibName)
    }
    
    private func setupPublisher() {
        thoughtPublisher = NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange)
            .sink { [weak self] notification in
                let objects = PersistenceManager.UpdateNotification(notification).changedObjects
                if objects is [Thought] {
                    self?.thought = objects.first as? Thought
                } else if objects is [RestructuredThought] {
                    self?.thought.restructuredThought = objects.first as? RestructuredThought
                }
                self?.tableView.reloadData()
            }
    }
    
    
    
    
    // MARK: - Actions
    
    private func deleteResponses() {
        PersistenceManager.shared.delete(thought.restructuredThought)
    }
    
    private func deleteThought() {
        PersistenceManager.shared.delete(thought)
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - UITableViewDataSource/Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .thought:
            return 1
        case .cognitiveChallenges:
            return CognitiveChallenge.allCases.count
        case .actions(let actions):
            return actions.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .thought:
            return thoughtCell(at: indexPath)
        case .cognitiveChallenges:
            return restructuredThoughtCell(at: indexPath)
        case .actions(let actions):
            return actionCell(at: indexPath, with: actions[indexPath.row])
        }
    }
    
    private func thoughtCell(at indexPath: IndexPath) -> ThoughtCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCell", for: indexPath) as! ThoughtCell
        cell.titleLabel.text = thought?.contents
        cell.distress = thought?.distress
        cell.selectionStyle = .none
        return cell
    }
    
    private func restructuredThoughtCell(at indexPath: IndexPath) -> RestructuredThoughtCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestructuredThoughtCell", for: indexPath) as! RestructuredThoughtCell
        let challenge = CognitiveChallenge.allCases[indexPath.row]
        cell.questionLabel.text = challenge.question
        cell.answerLabel.text = thought.restructuredThought?.answer(to: challenge)
        return cell
    }
    
    private func actionCell(at indexPath: IndexPath, with type: Section.ActionType) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell", for: indexPath)
        cell.textLabel?.text = type.rawValue
        cell.textLabel?.textColor = type.isDestructive ? .systemRed : .systemIndigo
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard case let Section.actions(actions) = sections[indexPath.section] else {
            return
        }

        switch actions[indexPath.row] {
        case .edit:
            perform(segue: .editThought)
        case .restructure, .editResponses:
            perform(segue: .restructureThought)
        case .deleteResponses:
            let alertMessage = "Are you sure you want to delete your responses? This action cannot be undone."
            let alert = UIAlertController(title: "Delete responses", message: alertMessage, preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in self.deleteResponses() }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        case .delete:
            let alertMessage = "Are you sure you want to delete this thought? This action cannot be undone."
            let alert = UIAlertController(title: "Delete thought", message: alertMessage, preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in self.deleteThought() }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Helpers
    
    private var sections: [Section] {
        if thought.restructuredThought == nil {
            return [.thought, .actions([.edit, .restructure, .delete])]
        } else {
            return [.thought, .cognitiveChallenges, .actions([.editResponses, .deleteResponses]), .actions([.edit, .delete])]
        }
    }
    
    private enum Section {
        
        case thought
        case cognitiveChallenges
        case actions([ActionType])
        
        enum ActionType: String {
            
            case edit = "Edit thought"
            case restructure = "Restructure thought"
            case delete = "Delete thought"
            case editResponses = "Edit responses"
            case deleteResponses = "Delete responses"
            
            var isDestructive: Bool {
                return self == .delete || self == .deleteResponses
            }
            
        }
        
    }
    
}
