//
//  ATMs.swift
//  assignment
//
//  Created by QuocHoi on 9/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class AFSBank: Object {
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var image: String = ""

    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class AFSATM: Object, MKAnnotation {
    dynamic var id: String = ""
    
    dynamic var bank: String = ""
    dynamic var city: String = ""
    dynamic var address: String = ""
    dynamic var quality: Int = 0
    dynamic var service: String = ""
    
    
    dynamic var latitude: Double = 0
    dynamic var longtitude: Double = 0
    
    dynamic var created_at: NSDate?
    dynamic var updated_at: NSDate?

    
    override static func primaryKey() -> String? {
        return "id"
    }
    
   
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longtitude)
    }
    
    var geocoord: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longtitude)
    }

    func distanceFromLocation() -> String {
        return ""
    }
    
    // Realm object
    class func find(predict: String = "") throws -> [AFSATM]? {
        let realm = try! Realm()
        var objectList = realm.objects(AFSATM.self)
        
        if predict != "" {
            objectList = objectList.filter(predict)
        }
        objectList = objectList.sorted("updated_at", ascending: false)
        var result: [AFSATM] = []
        for object in objectList {
            result.append(object)
        }
        return result
    }
    
    func insert() throws {
        let realm = try! Realm()
        try! realm.write {
            self.id = NSUUID().UUIDString
            self.created_at = NSDate()
            self.updated_at = NSDate()
            realm.add(self)
        }
    }
    
    func update(bank bank: String = "",city: String = "", address: String = "", quality: Int = 0, service: String = "",latitude: Double = 0.0, longitude: Double = 0.0 ) throws {
        let realm = try! Realm()
        try! realm.write {
            self.bank = bank
            self.city = city
            self.address = address
            self.quality = quality
            self.service = service
            self.latitude = latitude
            self.longtitude = longitude
            
            self.updated_at = NSDate()
        }
    }
    
    func delete() throws {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
}
