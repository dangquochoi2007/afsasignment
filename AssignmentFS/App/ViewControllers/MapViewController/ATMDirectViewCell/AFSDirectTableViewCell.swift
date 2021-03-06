//
//  AFSDirectTableViewCell.swift
//  assignment
//
//  Created by QuocHoi on 10/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import UIKit

class AFSDirectTableViewCell: UITableViewCell {
    static let identifier = "AFSDirectTableViewCell"

    @IBOutlet weak var directionImageView: UIImageView!
    @IBOutlet weak var stepGuideLabel: UILabel!
    @IBOutlet weak var distanceStepLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
