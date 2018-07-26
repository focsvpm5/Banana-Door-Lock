//
//  userController.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/7/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import UIKit
import SwiftMQTT
import RealmSwift

class userController: UIViewController {
    
    var selectToRoom : selectedRoom!
    
    let realm = try! Realm()
    
    // Profile
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    
    var mqttSession: MQTTSession!
    
    var statusMQTT = ""
    
    @IBOutlet weak var lockPressed: UIButton!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var historyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set mqtt
        
        mqttSession = MQTTSession(host: "m10.cloudmqtt.com", port: 18771, clientID: "AAA", cleanSession: true, keepAlive: 15, useSSL: false)
        mqttSession.username = "nhuivzzk"
        mqttSession.password = "p346wIR6o_t1"
        mqttSession.delegate = self
        
        // mqtt connect
        
        mqttSession.connect { (succeeded, error) -> Void in
            if succeeded {
                print("Connected!")
            } else {
                print("error")
            }
        }
        
        // mqtt subscrib
        
        mqttSession.subscribe(to: "Doorlock", delivering: .atMostOnce) { (succeeded, error) -> Void in
            if succeeded {
                print("Subscribed!")
            }
        }
        
        // Image needs to be added to project.
        let buttonIcon = UIImage(named: "back")
        
        let leftBarButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.done, target: self, action: #selector(userController.myLeftSideBarButtonItemTapped))
        leftBarButton.image = buttonIcon
        leftBarButton.tintColor = .white
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        print(selectToRoom)
        //self.title = "Room \(selectToRoom.room_id)"
        self.navigationItem.title = "Room \(selectToRoom.room_id)"
        
        historyButton.layer.cornerRadius = 10
        
        if let userDoorlock = realm.objects(userDoor.self).last {
            self.configure(withRealm: userDoorlock)
        }
    }
    
    @objc func myLeftSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        print("myLeftSideBarButtonItemTapped")
        let selectRoomView = self.storyboard?.instantiateViewController(withIdentifier: "selectedRoomViewController")as! UINavigationController
        self.present(selectRoomView, animated: true, completion: nil)
    }
    
    // configure profile
    func configure(withRealm realm: userDoor) -> (Void) {
        
        firstName.text = realm.firstName
        lastName.text = realm.lastName
        if realm.picture != "" {
            let url = URL(string: "\(realm.picture)")
            let dataImage = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            self.userProfile.image = UIImage(data: dataImage!)
        }
    }
    
    @IBAction func historyPressed(_ sender: UIButton) {
        let calendarView = storyboard?.instantiateViewController(withIdentifier: "FSCalendarScopeExampleViewController")as! FSCalendarScopeExampleViewController
        let userSelect = self.selectToRoom
        calendarView.historyToRoom = userSelect
        print("AAAAAAAAAAAAAAAAAAAAA: \(userSelect!)")
        //present(userView, animated: true, completion: nil)
        self.navigationController?.pushViewController(calendarView, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBAction func lockAnimation(_ sender: UIButton) {
            
            // change status
            statusLabel.textColor = .green
            statusLabel.text = "Open"
            
            // change image
            
            lockPressed.setImage(#imageLiteral(resourceName: "unlock"), for: UIControlState.normal)
            
            // mqtt publish
            
            let channel = "Doorlock"
            let message = "unlocked"
            let data = message.data(using: .utf8)!
            mqttSession.publish(data, in: channel, delivering: .atMostOnce, retain: false) {
                (succeeded, error) -> Void in
                if succeeded {
                    print("Published!")
                }
            }
    }
    
//    func mqttSession(session: MQTTSession, received message: Data, in topic: String) {
//        let string = String(data: message, encoding: .utf8)!
//        print(string)
//    }

}

extension userController: MQTTSessionDelegate {
    
    func mqttDidReceive(message data: Data, in topic: String, from session: MQTTSession) {
        let string = String(data: data, encoding: .utf8)!
        print(string)
        statusMQTT = string
        if statusMQTT == "locked" {
            
            // change status
            statusLabel.textColor = .red
            statusLabel.text = "Close"
            
            //change image
            lockPressed.setImage(#imageLiteral(resourceName: "padlock"), for: UIControlState.normal)
        }
    }
    
    func mqttDidDisconnect(session: MQTTSession) {
        print("Disconnect")
    }
    
    func mqttSocketErrorOccurred(session: MQTTSession) {
        print("SocketError")
    }
    
}

