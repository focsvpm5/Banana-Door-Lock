//
//  userRealm.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/18/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import RealmSwift

class userDoor: Object {
    
    @objc dynamic var token: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var userId: String = ""
    @objc dynamic var userRole: String = ""
    @objc dynamic var picture: String = ""
    
    
    convenience init(_token : String, _firstName : String, _lastName : String, _userId : String, _userRole : String, _picture : String) {
        self.init()
        self.token = _token
        self.firstName = _firstName
        self.lastName = _lastName
        self.token = _token
        self.userId = _userId
        self.userRole = _userRole
        self.picture = _picture
    }
    
    override class func primaryKey() -> String {
        return "userId"
    }
    
}

