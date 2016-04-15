//
//  AFSATMTableViewCell.swift
//  assignment
//
//  Created by QuocHoi on 10/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import UIKit

class AFSATMTableViewCell: UITableViewCell {
    static var identifier:String = "AFSATMTableViewCell"
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var nameBankLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var atm: AFSATM?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.AFSCherryColor().CGColor
        self.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initAppearance() {
        guard let activeATM = self.atm  else {
            return
        }
        
        self.addressLabel.text = activeATM.address
        self.serviceLabel.text = activeATM.service
        self.nameBankLabel.text = activeATM.bank
        self.distanceLabel.text = activeATM.distanceFromLocation()
        
        
    }
    
}
