//
//  RestructureThoughtNavigationController.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 21/9/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

class RestructureThoughtNavigationController: UINavigationController, UIAdaptivePresentationControllerDelegate {
    
    var restructuredThought: RestructuredThought?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        presentationController?.delegate = self
        
        if let restructureThoughtViewController = topViewController as? RestructureThoughtViewController {
            restructureThoughtViewController.challenge = CognitiveChallenge.allCases.first
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        PersistenceManager.shared.saveIfNecessary()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        let restructureThoughtViewController = viewController as! RestructureThoughtViewController // Cannot push other VCs
        let currentChallenge = (topViewController as? RestructureThoughtViewController)?.challenge

        guard let nextChallenge = currentChallenge?.nextChallenge else {
            return dismiss(animated: true, completion: nil)
        }
        
        restructureThoughtViewController.challenge = nextChallenge
        super.pushViewController(restructureThoughtViewController, animated: animated)
        
    }
    
    
    // MARK: - UIAdaptivePresentationControllerDelegate
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        PersistenceManager.shared.saveIfNecessary()
    }

}
