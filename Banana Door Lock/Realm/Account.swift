//
//  Account.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/6/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import RealmSwift

class Account: Object {
    
    @objc dynamic var userId: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var gender: String = ""
    @objc dynamic var addr: String = ""
    @objc dynamic var tel: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var imgUrl: String = ""
    @objc dynamic var token: String = ""
    @objc dynamic var userType: String = ""
    
    
    convenience init(_userId : String, _firstName : String, _lastName : String, _gender : String , _addr : String , _tel : String , _email : String , _imgUrl : String , _token : String , _userType : String) {
        self.init()
        self.userId = _userId
        self.firstName = _firstName
        self.lastName = _lastName
        self.gender = _gender
        self.addr = _addr
        self.tel = _tel
        self.email = _email
        self.imgUrl = _imgUrl
        self.token = _token
        self.userType = _userType
    }
    
    override class func primaryKey() -> String {
        return "userId"
    }
    
}

