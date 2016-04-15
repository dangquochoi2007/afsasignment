//
//  AFSContainterViewController.swift
//  AssignmentFS
//
//  Created by QuocHoi on 13/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import Foundation
import UIKit


class AFSContainerViewController : AFSBaseViewController {
    

    
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
    
    @IBAction func addATMButtonPressed(sender: UIBarButtonItem) {
    }
    
    @IBAction func mapButtonPressed(sender: UIBarButtonItem) {
//        if sender.tag == 0 {
//            sender.tag = 1
//            self.animationFlipFromView(self.listLocationContainerView, toView: self.mapLocationContainerView, animation: 0.3)
//        } else {
//            sender.tag = 0
//            self.animationFlipFromView(self.mapLocationContainerView, toView: self.listLocationContainerView, animation: 0.3)
//        }
    }
    
    func switchMapvsListView() {
        
    }
    
    func animationFlipFromView(fromView: UIView, toView: UIView, animation: NSTimeInterval) {
        
        UIView.transitionFromView(fromView, toView: toView, duration: animation, options: .TransitionFlipFromTop, completion: nil)
    }
}