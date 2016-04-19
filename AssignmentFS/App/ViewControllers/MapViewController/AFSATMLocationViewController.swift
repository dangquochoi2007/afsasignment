//
//  AFSATMLocationViewController.swift
//  AssignmentFS
//
//  Created by QuocHoi on 13/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import LKAlertController


class AFSATMLocationViewController: AFSBaseViewController, UITableViewDelegate, UITableViewDataSource, AFSATMEmptyBackgroundDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var atmLocationTableView: UITableView!
    
    var locationManager: CLLocationManager!
    var regionRadius:Double = 1000
    var currentUserLocation: CLLocation? {
        didSet {
            if currentUserLocation != nil {
                self.atmLocationTableView.reloadData()
            }
        }
    }
    
    
    lazy var emptyBackgroundView: UIView? = {
        let emptybackground = AFSATMEmptyBackgroundView.loadNib()
        emptybackground.delegate = self
        return emptybackground
    }()
    
    var atmListLocal = [AFSATM]() {
        didSet {
            self.atmLocationTableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initAppearance()
        self.makeRefresh()
        self.animationTable()
        
        //Init appearance location
        self.initAppearanceLocationManager()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.makeRefresh()
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "AFSATMMapViewController_Segue_Map" {
            print("AFSATMMapViewController_Segue_Map")
            let destinationViewController = segue.destinationViewController as! AFSATMMapViewController
            destinationViewController.showDirection = false
            destinationViewController.showLocalLocation = true
            destinationViewController.atmLocation = self.atmListLocal
        } else if segue.identifier == "AFSATMViewController_Segue" {
            let destionationViewController = segue.destinationViewController as! AFSATMViewController
            destionationViewController.currentUserLocation = self.currentUserLocation?.coordinate
        }
     }
 
    
    // MARK: Init
    func initAppearance() {
        self.atmLocationTableView.delegate = self
        self.atmLocationTableView.dataSource = self
        
        self.atmLocationTableView.registerNib(UINib(nibName: AFSATMTableViewCell.identifier ,bundle: nil), forCellReuseIdentifier: AFSATMTableViewCell.identifier)
        
        self.atmLocationTableView.rowHeight = UITableViewAutomaticDimension
        self.atmLocationTableView.estimatedRowHeight = 160.0
        
        
        
    }
    
    func makeRefresh() {
        do {
            if let atmListLocalData = try AFSATM.find() {
                self.atmListLocal = atmListLocalData
            }
        } catch {
            Alert(title: "ATM location is empty",
                message: "Please add more ATM position")
                .addAction("Close")
                .show()
            
        }
    }
    
    
    /// MARK: UITableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.atmListLocal.count <= 0 {
            self.atmLocationTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            self.atmLocationTableView.backgroundView?.hidden = false
            self.atmLocationTableView.backgroundView = self.emptyBackgroundView
            self.atmLocationTableView.scrollEnabled = true
            
        } else {
            self.atmLocationTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            self.atmLocationTableView.backgroundView?.hidden = true
            
        }
        return 1
    }
    
    // MARK: Table View Controller Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.atmListLocal.count
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AFSATMTableViewCell.identifier, forIndexPath: indexPath) as! AFSATMTableViewCell
        cell.atm = self.atmListLocal[indexPath.row]
        cell.initAppearance()
        if let userLocation = currentUserLocation {
            let atmCllocation = CLLocation(latitude: cell.atm!.latitude, longitude: cell.atm!.longtitude)
            let travelDistance = userLocation.distanceFromLocation(atmCllocation)
            cell.distanceLabel.text = travelDistance.distance()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("AFSATMTableViewCell")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapDirection = storyboard.instantiateViewControllerWithIdentifier(AFSATMMapViewController.identifier) as! AFSATMMapViewController
        mapDirection.atmLocation = [self.atmListLocal[indexPath.row]]
        mapDirection.showDirection =  true
        mapDirection.showLocalLocation = true
        self.navigationController?.pushViewController(mapDirection, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 120
        
    }
    
    // MARK: Animation
    func animationTable() {
        self.atmLocationTableView.reloadData()
        let cells = self.atmLocationTableView.visibleCells
        let tableHeight: CGFloat = self.atmLocationTableView.bounds.size.height
        
        for i in cells {
            let cell:AFSATMTableViewCell = i as! AFSATMTableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        var index = 0
        for c in cells {
            let cell: AFSATMTableViewCell = c as! AFSATMTableViewCell
            UIView.animateWithDuration(1.5,
                                       delay: 0.01 * Double(index),
                                       usingSpringWithDamping: 0.8,
                                       initialSpringVelocity: 0,
                                       options: .CurveEaseInOut,
                                       animations: {
                                        cell.transform = CGAffineTransformMakeTranslation(0, 0)
                                        },
                                       completion: nil)
            // increase index reduce time
            index += 1
        }
        
    }
    
    // CL location delegate
    func createLocationManager(startImediately startImediately: Bool) {
        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.distanceFilter = 50
            self.locationManager.startUpdatingLocation()
        }
    }
    
    
    func initAppearanceLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            
            self.createLocationManager(startImediately: true)
        } else {
            Alert(title: "Title", message: "Message")
                .addAction("Close")
                .addAction("Open Setting", style: .Default, handler: { _ in
                    if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }).show()
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("update didUpdateLocations")

        if locations.count > 0 {
            self.currentUserLocation = locations.last
            debugPrint(self.currentUserLocation)
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            break
        case .NotDetermined:
            self.locationManager.requestAlwaysAuthorization()
        default:
            Alert(title: "Location Access Disabled",
                message: "In order to be notified about ATM near you, please open this app's settings and set location access to 'Always'.")
                .addAction("Open Settings", style: .Default, handler: { _ in
                    //open setting application url
                    if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }).show()
            return
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        Alert(title: "Error find your location", message: "Location manager failed with error = \(error.localizedDescription). Please make sure enable location in setting")
            .addAction("Close")
            .show()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        print("Latitude = \(newLocation.coordinate.latitude)")
        print("Longitude = \(newLocation.coordinate.longitude)")
    }
    


}
