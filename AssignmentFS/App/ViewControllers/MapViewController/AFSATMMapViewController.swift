//
//  AFSATMMapViewController.swift
//  AssignmentFS
//
//  Created by QuocHoi on 15/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import UIKit
import MapKit
import RealmMapView


class AFSATMMapViewController: AFSBaseViewController, MKMapViewDelegate  {
    static let identifier = "AFSATMMapViewController"
    
    
    @IBOutlet weak var atmLocationMapView: MKMapView!
    
    var atmLocation: [AFSATM]?
    
    var showDirection: Bool = true
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
