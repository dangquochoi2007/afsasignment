//
//  UIViewShake.swift
//  assignment
//
//  Created by QuocHoi on 12/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import Foundation
import UIKit


/**
 @enum ShakeDirection
 Enum that specifies the direction of the shake
 */
public enum ShakeDirection : Int {
    case Horizontal = 0
    case Vertical = 1
}

extension UIView {
    /**
     Shake the UITextField.
     
     Shake the text field with default values.
     */
    func shake() {
        self.shake(10, withDelta: 5, completion: nil)
    }
    
    /**
     Shake the UITextField.
     
     Shake the text field a given number of times.
     
     :param: times The number of shakes.
     :param: delta The width of the shake.
     */
    func shake(let times: Int,
                   let withDelta delta: CGFloat) {
        self.shake(times, withDelta: delta, completion: nil)
    }
    
    /**
     Shake the UITextField.
     
     Shake the text field a given number of times.
     
     :param: times The number of shakes.
     :param: delta The width of the shake.
     :param: handler A block object to be executed when the shake sequence ends.
     */
    func shake(let times: Int,
                   let withDelta delta: CGFloat,
                                 let completion handler: (() -> Void)?) {
        self._shake(times, direction: 1, currentTimes: 0, withDelta: delta, speed: 0.03, shakeDirection: ShakeDirection.Horizontal, completion: handler)
    }
    
    /**
     Shake the UITextField at a custom speed.
     
     Shake the text field a given number of times with a given speed.
     
     :param: times The number of shakes.
     :param: delta The width of the shake.
     :param: interval The duration of one shake.
     */
    func shake(let times: Int,
                   let withDelta delta: CGFloat,
                                 let speed interval: NSTimeInterval) {
        self.shake(times, withDelta: delta, speed: interval, completion: nil)
    }
    
    /**
     Shake the UITextField at a custom speed.
     
     Shake the text field a given number of times with a given speed.
     
     :param: times The number of shakes.
     :param: delta The width of the shake.
     :param: interval The duration of one shake.
     :param: handler A block object to be executed when the shake sequence ends.
     */
    func shake(let times: Int,
                   let withDelta delta: CGFloat,
                                 let speed interval: NSTimeInterval,
                                           let completion handler: (() -> Void)?) {
        self._shake(times, direction: 1, currentTimes: 0, withDelta: delta, speed: interval, shakeDirection: ShakeDirection.Horizontal, completion: handler)
    }
    
    /**
     Shake the UITextField at a custom speed.
     
     Shake the text field a given number of times with a given speed.
     
     :param: times The number of shakes.
     :param: delta The width of the shake.
     :param: interval The duration of one shake.
     :param: direction of the shake.
     */
    func shake(let times: Int,
                   let withDelta delta: CGFloat,
                                 let speed interval: NSTimeInterval,
                                           let shakeDirection: ShakeDirection) {
        self.shake(times, withDelta: delta, speed: interval, shakeDirection: shakeDirection, completion: nil)
    }
    
    /**
     Shake the UITextField at a custom speed.
     
     Shake the text field a given number of times with a given speed.
     
     :param: times The number of shakes.
     :param: delta The width of the shake.
     :param: interval The duration of one shake.
     :param: direction of the shake.
     :param: handler A block object to be executed when the shake sequence ends.
     */
    func shake(let times: Int,
                   let withDelta delta: CGFloat,
                                 let speed interval: NSTimeInterval,
                                           let shakeDirection: ShakeDirection,
                                               let completion handler: (() -> Void)?) {
        self._shake(times, direction: 1, currentTimes: 0, withDelta: delta, speed: interval, shakeDirection: shakeDirection, completion: handler)
    }
    
    
    private func _shake(let times: Int,
                            let direction: Int,
                                let currentTimes current: Int,
                                                 let withDelta delta: CGFloat,
                                                               let speed interval: NSTimeInterval,
                                                                         let shakeDirection: ShakeDirection,
                                                                             let completion handler: (() -> Void)?) {
        
        UIView.animateWithDuration(interval, animations: {
            () -> Void in
            self.transform = (shakeDirection == ShakeDirection.Horizontal) ?
                CGAffineTransformMakeTranslation(delta * CGFloat(direction), 0) :
                CGAffineTransformMakeTranslation(0, delta * CGFloat(direction))
            }, completion: {
                (let finished: Bool) in
                if current >= times {
                    UIView.animateWithDuration(interval, animations: {
                        () -> Void in
                        self.transform = CGAffineTransformIdentity
                        }, completion: {
                            (let finished: Bool) in
                            if let handler = handler {
                                handler()
                            }
                    })
                    return
                }
                self._shake(times - 1,
                    direction: direction * -1,
                    currentTimes: current + 1,
                    withDelta: delta,
                    speed: interval,
                    shakeDirection: shakeDirection,
                    completion: handler)
        })
    }
    
    // Make border color
    func addRedBorder() {
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.redColor().CGColor
        self.layer.borderWidth = 1
    }
    
    func removeRedBorder() {
        self.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    ///
    class func loadNib<T: UIView>(viewType: T.Type) -> T {
        let className = String.className(viewType)
        return NSBundle.mainBundle().loadNibNamed(className, owner: nil, options: nil).first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    
}