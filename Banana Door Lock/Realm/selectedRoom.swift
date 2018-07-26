//
//  selectedRoom.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/23/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import RealmSwift

class selectedRoom: Object {
    
    @objc dynamic var room_id: String = ""
    
    convenience init(_room_id : String) {
        self.init()
        self.room_id = _room_id
    }
    
    override class func primaryKey() -> String {
        return "room_id"
    }
    
}
