//
//  CognitiveChallenge.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 21/9/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import Foundation

enum CognitiveChallenge: CaseIterable {
    
    /// The evidence in favour of the thought being true
    case evidenceFor
    /// The evidence in favour of the thought being untrue
    case evidenceAgainst
    /// The advice that one would give to a friend with the same thought
    case adviceToFriend
    /// The perceived helpfulness of holding the thought to be true
    case perceivedHelpfulness
    /// The restructured version of the original thought
    case restructuredThought
    
    /// The question to ask the person doing the cognitive challenging
    var question: String {
        switch self {
        case .evidenceFor:
            return "What evidence do you have for the thought?"
        case .evidenceAgainst:
            return "What evidence do you have against the thought?"
        case .adviceToFriend:
            return "What would you tell a friend (to help them) if they had the thought?"
        case .perceivedHelpfulness:
            return "What does the thought do for you? How does it make you feel? Is it helpful in any way, or is it just distressing?"
        case .restructuredThought:
            return "How would you re-write this thought?"
        }
    }
    
    var nextChallenge: CognitiveChallenge? {
        guard let currentIndex = Self.allCases.firstIndex(of: self), currentIndex < Self.allCases.count else {
            return nil
        }
        
        return Self.allCases[currentIndex + 1]
    }
    
}
