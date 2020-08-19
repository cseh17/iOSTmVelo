//
//  AnimationFactory.swift
//  TmVelo
//
//  Created by Cseh Krisztian on 07.08.19.
//  Copyright © 2019 Cseh Krisztian. All rights reserved.
//

import UIKit

typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void

// MARK: - Animation types
// Declare and define animation types
enum AnimationFactory{
    
    // Implementation of move up with fade animation. This type of animation is designed to be used on table display. It is suppoused to be called on willBeDisplayed delegate function.
    static func makeMoveUpWithFade(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation {
        return { cell, indexPath, tableView in
            
            // Before animation position and appearance of cell
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight / 2)
            cell.alpha = 0.0
            
            // Animation implementation. In this function the final appearance and position of the cell have to be defined
            UIView.animate(withDuration: duration,
                           delay: delayFactor * Double(indexPath.row),
                           options: [.curveEaseIn],
                           animations:{
                            cell.transform = CGAffineTransform(translationX: 0, y: 0)
                            cell.alpha = 1.0
            })
        }
    }
}
