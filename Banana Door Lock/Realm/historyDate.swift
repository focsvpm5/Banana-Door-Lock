//
//  historyDate.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/23/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import RealmSwift

class historyDate: Object {
    
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var date: String = ""
    
    convenience init(_firstName : String, _lastName : String, _date : String) {
        self.init()
        self.firstName = _firstName
        self.lastName = _lastName
        self.date = _date
    }
    
    override class func primaryKey() -> String {
        return "date"
    }
    
}
