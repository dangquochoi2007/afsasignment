//
//  AFSBaseViewController.swift
//  assignment
//
//  Created by QuocHoi on 7/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import UIKit
import CoreLocation


class AFSBaseViewController: UIViewController, CLLocationManagerDelegate {

    var activeTextField: UITextField!
    var scrollView: UIScrollView!
    
    lazy var locationManager: CLLocationManager = {
        var location = CLLocationManager()
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.requestAlwaysAuthorization()
        location.startUpdatingLocation()
        return location
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //

    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }

}
