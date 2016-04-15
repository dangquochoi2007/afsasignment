//
//  AFSATMEmptyBackgroudView.swift
//  AssignmentFS
//
//  Created by QuocHoi on 13/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import UIKit

protocol AFSATMEmptyBackgroundDelegate: class{
    func makeRefresh()
}

class AFSATMEmptyBackgroundView: UIView {
    
    var delegate: AFSATMEmptyBackgroundDelegate?
    
    @IBAction func refeshButtonPressed(sender: UIButton) {
        self.delegate?.makeRefresh()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
