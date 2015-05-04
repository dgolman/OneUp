
//
//  TimelineTableViewCell.swift
//  OneUp
//
//  Created by Daniel Golman on 4/28/15.
//  Copyright (c) 2015 Daniel Golman. All rights reserved.
//

import UIKit

class TimelineTableViewCell: PFTableViewCell {

    @IBOutlet weak var firstHandleImageView: UIImageView!
    @IBOutlet weak var secondHandleImageView: UIImageView!
    @IBOutlet weak var firstHandleLikes: UILabel!
    @IBOutlet weak var secondHandleLikes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
