//
//  SideMenuTableViewCell.swift
//  TmVelo
//
//  Created by Cseh Krisztian on 06.08.19.
//  Copyright © 2019 Cseh Krisztian. All rights reserved.
//

import UIKit

// MARK: SideMenu - Settings TableViewCell
class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var sideMenuSettingsCellTitle: UILabel!
    @IBOutlet weak var sideMenuSettingsCellIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // Function that creates and adds a separator inbetween the table view cells. The separator itself is a subview that fills the gab inbetween the cell in the table view and the self itself. In this way a custom thickness for the separator can be defined.
    func setSeparator(isLast: Bool) {
        
        // Create and ad a subview in order to simulate a thicker separator.
        let mCellSize = UIScreen.main.bounds
        let separatorHeight = CGFloat(1)
        let addSeparator = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height - separatorHeight, width: mCellSize.width, height: separatorHeight))
        addSeparator.backgroundColor = #colorLiteral(red: 0.462745098, green: 0.4078431373, blue: 0.6039215686, alpha: 1)
        
        if !isLast {
            self.addSubview(addSeparator)
        }
        
    }
}
