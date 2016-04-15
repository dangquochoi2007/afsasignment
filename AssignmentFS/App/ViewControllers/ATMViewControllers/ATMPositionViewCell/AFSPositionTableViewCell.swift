//
//  AFSPositionTableViewCell.swift
//  AssignmentFS
//
//  Created by QuocHoi on 15/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import UIKit
protocol AFSPositionTableViewCellDelegate {
    func makeChooseAtm(atm: AFSATM?)
}
class AFSPositionTableViewCell: UITableViewCell {
    static let identifier = "AFSPositionTableViewCell"

    @IBOutlet weak var locationMarkImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameBankLabel: UILabel!
    
    var delegate: AFSPositionTableViewCellDelegate?
    
    var atm: AFSATM? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.locationMarkImageView.layer.masksToBounds = true
        self.locationMarkImageView.layer.borderColor = UIColor.AFSCherryColor().CGColor
        self.locationMarkImageView.layer.borderWidth = 1.0
        self.locationMarkImageView.layer.cornerRadius = self.locationMarkImageView.bounds.size.width/2
        
        // Initialization code
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handle(_:)))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initAppearance() {
        guard let position = self.atm else {
            return
        }
        
        self.addressLabel.text = position.address
        self.nameBankLabel.text = position.bank
    }
    
    func handle(sender: UIGestureRecognizer) {
        
        self.delegate?.makeChooseAtm(self.atm)
    }
    
}
