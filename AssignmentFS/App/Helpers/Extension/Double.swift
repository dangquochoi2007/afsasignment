//
//  Double.swift
//  AssignmentFS
//
//  Created by QuocHoi on 18/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import Foundation

extension Double {
    func distance() -> String {
        let m = self
        if m > 1000 {
            return String(format: "%0.2f km", m/1000)
        } else {
            return String(format: "%0.2f m", m)
        }
    }
    
}