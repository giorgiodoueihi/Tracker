//
//  ThoughtDetailViewController.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 8/10/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

class ThoughtDetailViewController: UITableViewController {
    
    var thought: Thought?
    var restructuredThought: RestructuredThought?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ThoughtCell", bundle: nil), forCellReuseIdentifier: "ThoughtCell")
    }
    
    
    // MARK: - UITableViewDataSource/Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return CognitiveChallenge.allCases.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section > 0 {
            return restructuredThoughtCell(at: indexPath)
        } else {
            return thoughtCell(at: indexPath)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Restructured Thought", for: indexPath) as! RestructuredThoughtCell
        let challenge = CognitiveChallenge.allCases[indexPath.row]
        cell.questionLabel.text = challenge.question
        cell.answerLabel.text = restructuredThought?.answer(to: challenge)
        return cell
    }
    
}
