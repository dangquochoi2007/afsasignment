//
//  AFSBaseViewController.swift
//  assignment
//
//  Created by QuocHoi on 7/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class AFSBaseViewController: UIViewController {

    var activeTextField: UITextField!
    var scrollView: UIScrollView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    //
    
    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print("didFailWithError")
//        
//    }
//    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locationValue: CLLocationCoordinate2D = self.locationManager.location!.coordinate
//        print(locationValue.latitude)
//        print(locationValue.longitude)
//        
//    }
//    
//    
//    func calculateCoordinateWithRegon(location: CLLocation) -> (CLLocationCoordinate2D, CLLocationCoordinate2D) {
//        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
//        
//        
//        var start: CLLocationCoordinate2D = CLLocationCoordinate2D()
//        var stop: CLLocationCoordinate2D = CLLocationCoordinate2D()
//        
//        start.latitude = region.center.latitude + (region.span.latitudeDelta / 2.0)
//        start.longitude = region.center.longitude - (region.span.longitudeDelta / 2.0)
//        stop.latitude = region.center.latitude - (region.span.latitudeDelta / 2.0)
//        stop.longitude = region.center.longitude - (region.span.longitudeDelta / 2.0)
//        
//        return (start, stop)
//    }

}
