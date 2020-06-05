//
//  HomeViewController.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 5/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var emptyStateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureEmptyState()
    }
    
    
    // MARK: - Configuring
    
    private func configureEmptyState() {
        tableView.isHidden = isEmpty
        emptyStateLabel.isHidden = !isEmpty
    }
    
    
    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = resultsController?.sections?[section]
        return section?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCell")!
        _ = resultsController?.object(at: indexPath)
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Helpers
    
    private var isEmpty: Bool {
        return resultsController?.sections?.isEmpty == true
    }
    
    private lazy var resultsController: NSFetchedResultsController<Thought>? = {
        let descriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        let controller = PersistenceManager.shared.fetchedResultsController(type: Thought.self, sectionedBy: "timestamp", sortedBy: descriptors)
        try? controller?.performFetch()
        return controller
    }()

}
