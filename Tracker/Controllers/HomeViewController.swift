//
//  HomeViewController.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 5/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var addButton: UIBarButtonItem!
    @IBOutlet private var emptyStateStackView: UIStackView!
    @IBOutlet private var progressView: CircularProgressView!
    
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .light)
    private var hapticWasCalled = false
    
    /// The currently selected index path for the table view
    
    private var selectedTableViewIndexPath: IndexPath? {
        didSet {
            if let newValue = selectedTableViewIndexPath, tableView.indexPathForSelectedRow == newValue {
                tableView.deselectRow(at: newValue, animated: true)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupTableView()
        setupPullToAddThoughtView()
        configureForEmptyState()
        navigationItem.leftBarButtonItem = editButtonItem
        hapticGenerator.prepare()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.segueIdentifier {
        case .viewThoughtDetail:
            let controller = segue.destination(as: ThoughtDetailViewController.self)
            controller.thought = thought(at: selectedTableViewIndexPath)
        case .editThought:
            let navigationController = segue.destination(as: UINavigationController.self)
            let thoughtInputViewController = navigationController.topViewController as? ThoughtInputViewController
            thoughtInputViewController?.thought = thought(at: selectedTableViewIndexPath)
        default:
            break
        }
    }
    
    
    // MARK: - Setup
    
    private func setupTableView() {
        let nibName = "ThoughtCell"
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: nibName)
    }
    
    private func setupPullToAddThoughtView() {
        progressView.progress = 0
    }
    
    
    // MARK: - Configuring
    
    private func configureForEmptyState() {
        tableView.isHidden = isEmpty
        emptyStateStackView.isHidden = !isEmpty
        setEditing(!isEmpty && isEditing, animated: false)
    }
    
    
    // MARK: - Actions
    
    @IBAction private func addThought() {
        perform(segue: .addNewThought)
    }
    
    
    // MARK: - UITableViewDataSource/Delegate

    func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = resultsController?.sections?[section]
        return section?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let indexPath = IndexPath(row: 0, section: section) /// If the section exists, then it must have at least one object
        guard let section = thought(at: indexPath) else {
            return nil
        }
        
        return sectionHeaderDateFormatter.string(from: section.timestamp)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCell") as! ThoughtCell
        let thought = self.thought(at: indexPath)
        cell.titleLabel.text = thought?.contents
        cell.distress = thought?.distress
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView.isEditing {
            return .init(actions: [deleteAction(forRowAt: indexPath)])
        } else {
            return .init(actions: [deleteAction(forRowAt: indexPath), editAction(forRowAt: indexPath)])
        }
    }
    
    private func deleteAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        return .init(style: .destructive, title: "Delete") { action, view, completion in
            let alertMessage = "Are you sure you want to delete this thought? This action cannot be undone."
            let alert = UIAlertController(title: "Delete thought", message: alertMessage, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                completion(false)
            }
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                let thought = self?.thought(at: indexPath)
                PersistenceManager.shared.delete(thought)
                completion(true)
            }
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func editAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        return .init(style: .normal, title: "Edit") { action, view, completion in
            self.selectedTableViewIndexPath = indexPath
            self.perform(segue: .editThought)
            completion(true)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        addButton.isEnabled = !editing
        editButtonItem.isEnabled = !isEmpty
        tableView.setEditing(editing, animated: animated)
        progressView.isHidden = editing
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTableViewIndexPath = indexPath
        perform(segue: .viewThoughtDetail)
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        @unknown default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        if type == .insert {
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        } else if type == .delete {
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        configureForEmptyState()
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = Float(min(-scrollView.contentOffset.y / 100, 1.0))
        progressView.progress = progress
        if progress >= 1.0, !hapticWasCalled {
            hapticGenerator.impactOccurred()
            hapticWasCalled = true
        } else if progress < 1.0, hapticWasCalled {
            hapticWasCalled = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if progressView.progress == 1.0, !tableView.isEditing {
            DispatchQueue.main.async { [weak self] in
                self?.addThought()
                self?.hapticGenerator.impactOccurred(intensity: 1)
                self?.hapticWasCalled = false
            }
        }
    }
    
    
    // MARK: - Helpers
    
    /// Returns the `Thought` in the `resultsController` at the given `IndexPath`, or `nil` if none exists
    ///
    /// - Parameters:
    ///     - indexPath: The `IndexPath` of the desired thought
    
    private func thought(at indexPath: IndexPath?) -> Thought? {
        guard let indexPath = indexPath, !isEmpty else {
            return nil
        }
        
        return resultsController?.object(at: indexPath)
    }
    
    /// Returns whether the `resultsController` is empty
    
    private var isEmpty: Bool {
        return resultsController?.sections?.isEmpty == true
    }
    
    private let sectionHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        formatter.calendar = .current
        formatter.locale = .current
        formatter.timeZone = .current
        return formatter
    }()
    
    /// The `NSFetchedResultsController` that acts as the data source for the controller's `UITableView`
    
    private lazy var resultsController: NSFetchedResultsController<Thought>? = {
        let descriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        let request = Thought.fetchRequest()
        request.sortDescriptors = descriptors
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: PersistenceManager.shared.primaryContext,
            sectionNameKeyPath: "isoTimestamp",
            cacheName: nil
        )
        controller.delegate = self
        try? controller.performFetch()
        return controller as? NSFetchedResultsController<Thought>
    }()

}
