//
//  CustomTableViewCell.swift
//  PhysioApp
//
//  Created by Terence Chua on 19/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFrame(_ frame: CGRect) {
        var frame = frame
        frame.origin.x += separatorInset.left
        frame.size.width -= 2 * separatorInset.left
        setFrame(frame)
    }

}
