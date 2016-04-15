//
//  UIColor.swift
//  AssignmentFS
//
//  Created by QuocHoi on 14/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//


#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

extension UIColor {
    
    
    public convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }
    
    
    public convenience init?(hexString: String, alpha: Float) {
        var hex = hexString
        if hex.hasPrefix("#") {
            hex = hex.substringFromIndex(hex.startIndex.advancedBy(1))
        }
        
        if (hex.rangeOfString("(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: NSStringCompareOptions.RegularExpressionSearch) != nil) {
            if hex.characters.count == 3 {
                let redHex = hex.substringFromIndex(hex.startIndex.advancedBy(1))
                let greenHex = hex.substringWithRange(Range<String.Index>(start: hex.startIndex.advancedBy(1), end: hex.startIndex.advancedBy(2)))
                let blueHex = hex.substringFromIndex(hex.startIndex.advancedBy(2))
                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }
            
            let redHex = hex.substringToIndex(hex.startIndex.advancedBy(2))
            let greenHex = hex.substringWithRange(Range<String.Index>(start: hex.startIndex.advancedBy(2), end: hex.startIndex.advancedBy(4)))
            let blueHex = hex.substringWithRange(Range<String.Index>(start: hex.startIndex.advancedBy(4), end: hex.startIndex.advancedBy(6)))
            
            
            var redUInt: CUnsignedInt = 0
            var greenUInt: CUnsignedInt = 0
            var blueUInt: CUnsignedInt = 0
            
            NSScanner(string: redHex).scanHexInt(&redUInt)
            NSScanner(string: greenHex).scanHexInt(&greenUInt)
            NSScanner(string: blueHex).scanHexInt(&blueUInt)
            
            self.init(red: CGFloat(redUInt)/255.0, green: CGFloat(greenUInt)/255.0, blue: CGFloat(blueUInt)/255.0, alpha: CGFloat(alpha))
            
            
            
        } else {
            self.init()
            return nil
        }
    }
    
    
    convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    
    convenience init?(hex: Int, alpha: Float) {
        var hexString = String(format: "%2X", hex)
        let leadingZerosString = String(count: 6 - hexString.characters.count, repeatedValue: Character("0"))
        hexString = leadingZerosString + hexString
        self.init(hexString: hexString as String, alpha: alpha)
    }
    
   
    //color="#8a92db"
    class func AFSNavigationColor() -> UIColor {
        return UIColor(hexString: "#949bde")!
    }
    
    class func AFSCherryColor() -> UIColor {
        return UIColor(hexString: "#949bde")!
    }
    
   
}