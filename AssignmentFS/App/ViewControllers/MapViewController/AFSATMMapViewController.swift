//
//  AFSATMMapViewController.swift
//  AssignmentFS
//
//  Created by QuocHoi on 15/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import UIKit
import MapKit
import LKAlertController

class AFSATMMapViewController: AFSBaseViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource  {
    static let identifier = "AFSATMMapViewController"
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var directionTableView: UITableView!
    @IBOutlet weak var atmLocationMapView: MKMapView!
    var currentUserLocation: CLLocation? {
        didSet {
            if self.currentUserLocation != nil {
                self.distanceAndHowLongToAnnotation()
            }
        }
    }
    
    var stepRouteDirection = [MKRouteStep]() {
        didSet {
            self.directionTableView.reloadData()
        }
    }
    
    
    var atmLocation = [AFSATM]()
    
    var showDirection: Bool = false
    var showLocalLocation = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.initAppearanceMapViewFromView()
        self.initAppearanceDirectionTable()
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.AFSCherryColor()
        self.navigationController?.navigationBar.tintColor = UIColor.AFSCherryColor()
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
    
    
    // MKMap Delegate 
    func initAppearanceMapViewFromView() {
        self.atmLocationMapView.delegate = self
        self.atmLocationMapView.showsCompass = true
        self.atmLocationMapView.showsScale = true
        self.atmLocationMapView.addAnnotations(self.atmLocation)
        if showLocalLocation {
            self.showuserLocationOnMapView()
        }
        
    }
    
    func showuserLocationOnMapView() {
        self.atmLocationMapView.showsUserLocation = true
        self.atmLocationMapView.userTrackingMode = .Follow
    }
    
    func initAppearanceDirectionTable() {
        self.directionTableView.delegate = self
        self.directionTableView.dataSource = self
        
        self.directionTableView.registerNib(UINib(nibName: AFSDirectTableViewCell.identifier,bundle:nil), forCellReuseIdentifier: AFSDirectTableViewCell.identifier)
        self.showDirectionTable(isShow: true)
    }
    
    func showDirectionTable(isShow isShow:Bool = true) {
        self.distanceLabel.hidden = isShow
        self.directionTableView.hidden = isShow
    }
    
   

    
    // MapView Delegae
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        print("Failed \(error)")
        Alert(title: "Error find your location", message: "Please make sure enable request location service")
            .addAction("Close")
            .addAction("Open Settings", style: .Default, handler: { _ in
                //Open setting
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }).show()
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        print("didUpdateUserLocation")
        debugPrint(userLocation)
        if self.currentUserLocation == nil {
            self.currentUserLocation = userLocation.location
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.AFSCherryColor()
        return renderer
    }
    
    //Direction Table Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stepRouteDirection.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AFSDirectTableViewCell.identifier, forIndexPath: indexPath) as! AFSDirectTableViewCell
        cell.stepGuideLabel.text = self.stepRouteDirection[indexPath.row].instructions
        cell.distanceStepLabel.text = self.stepRouteDirection[indexPath.row].distance.distance()
        return cell
    }
    
    /// Apple Map API
    func distanceAndHowLongToAnnotation() {
        if showDirection == false {
            return
        }
        
        guard let atm  = self.atmLocation.first where self.atmLocation.count == 1 else {
            Alert(title: "Error ATM Position", message: "We can not direction to this atm. Please try again later")
                .addAction("Close")
                .show()
            return
        }
        
        guard let userLocation = self.currentUserLocation?.coordinate else {
            Alert(title: "Error Direction Route", message: "We can not detect your location at this time. Please try again later")
                .addAction("Close")
                .show()
            return
        }
        let destinationLocation = atm.coordinate
        
        
        
        let request = MKDirectionsRequest()
        let sourcePlacemark = MKPlacemark(coordinate: userLocation, addressDictionary: nil)
        request.source = MKMapItem(placemark: sourcePlacemark)
        
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        
        request.transportType = MKDirectionsTransportType.Automobile
        request.requestsAlternateRoutes = true
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler( { (response: MKDirectionsResponse?, error: NSError?) in
            debugPrint(response)
            guard response != nil else {
                if error != nil {
                    Alert(title: "Error Direction Route", message: "\(error!.localizedDescription) Please try again later")
                        .addAction("Close")
                        .show()
                } else {
                    Alert(title: "Error Direction Route", message: "We can not direction to this atm. Please try again later")
                        .addAction("Close")
                        .show()
                }
                return
            }
            for route in response!.routes {
                print("Distance = \(route.distance)")
                self.distanceLabel.text = route.distance.distance()
                self.stepRouteDirection = route.steps
                self.showDirectionTable(isShow: false)
                self.atmLocationMapView.addOverlay(route.polyline)
                self.atmLocationMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
            
            
        })
    }
}
