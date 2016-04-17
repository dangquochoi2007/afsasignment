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

class AFSATMLocationViewController: AFSBaseViewController, UITableViewDelegate, UITableViewDataSource, AFSATMEmptyBackgroundDelegate {
    
    @IBOutlet weak var atmLocationTableView: UITableView!
    
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
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("AFSATMTableViewCell")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapDirection = storyboard.instantiateViewControllerWithIdentifier(AFSATMMapViewController.identifier) as! AFSATMMapViewController
        mapDirection.atmLocation = [self.atmListLocal[indexPath.row]]
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
    
    

}
