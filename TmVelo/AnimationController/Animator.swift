//
//  Animator.swift
//  TmVelo
//
//  Created by Cseh Krisztian on 07.08.19.
//  Copyright © 2019 Cseh Krisztian. All rights reserved.
//

import Foundation
import UIKit

final class Animator {
    private var hasAnimatedAllCells = false
    private let animation: Animation
    
    // Initialize animator
    init(animation: @escaping Animation) {
        self.animation = animation
    }
    
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else {
            return
        }
        
        animation(cell, indexPath, tableView)
        hasAnimatedAllCells = isLastCellVisible(at: indexPath, tableView: tableView)
    }
}
