//
//  NSUserDefault.swift
//  AssignmentFS
//
//  Created by QuocHoi on 15/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import Foundation


extension NSUserDefaults {
    
    func hasKey(key: String) -> Bool {
        return objectForKey(key) != nil
    }
    
    subscript(key: String) -> Proxy {
        return Proxy(self, key)
    }
    
    subscript(key: String) -> Any? {
        get {
            return self[key]
        }
        set {
            switch newValue {
            case let v as Int: setInteger(v, forKey: key)
            case let v as Double: setDouble(v, forKey: key)
            case let v as Bool: setBool(v, forKey: key)
            case let v as NSURL: setURL(v, forKey: key)
            case let v as NSObject: setObject(v, forKey: key)
            case nil: removeObjectForKey(key)
            default:
                assertionFailure("Invalid value type NSUserDefault")
            }
        }
    }
    
    func numberForKey(key: String) -> NSNumber? {
        return objectForKey(key) as? NSNumber
    }
    
    
    func remove(key: String) {
        removeObjectForKey(key)
    }
    
    class Proxy {
        private var defaults: NSUserDefaults
        private var key: String
        
        private init(_ defaults: NSUserDefaults, _ key: String) {
            self.defaults = defaults
            self.key = key
        }
        
        var string: String? {
            return defaults.stringForKey(key)
        }
        
        var array: NSArray? {
            return defaults.arrayForKey(key)
        }
        
        var dictionary: NSDictionary? {
            return defaults.dictionaryForKey(key)
        }
        
        var data: NSData? {
            return defaults.dataForKey(key)
        }
        
        
        var object: NSObject? {
            return self.defaults.objectForKey(key) as? NSObject
        }
        
        var date: NSDate? {
            return object as? NSDate
        }
        
        
        
        var number: NSNumber? {
            return defaults.numberForKey(key)
        }
        
        var int: Int? {
            return number?.integerValue
        }
        
        var double: Double? {
            return number?.doubleValue
        }
        
        var bool: Bool? {
            return number?.boolValue
        }
        
        var stringValue: String {
            return string ?? ""
        }
        
        
        var arrayValue: NSArray {
            return array ?? []
        }
        
        var dictionaryValue: NSDictionary {
            return dictionary ?? NSDictionary()
        }
        
        var dataValue: NSData {
            return data ?? NSData()
        }
        
        var numberValue: NSNumber {
            return number ?? 0
        }
        
        var intValue: Int {
            return int ?? 0
        }
        
        var doubleValue: Double {
            return double ?? 0.0
        }
        
        var boolValue: Bool {
            return bool ?? false
        }
        
        var exists: Bool {
            return defaults.hasKey(key)
        }
        
        func remove() {
            defaults.removeObjectForKey(key)
        }
    }
}