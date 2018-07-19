//
//  userController.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/7/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import UIKit
import SwiftMQTT

class userController: UIViewController {
    
    var mqttSession: MQTTSession!
    
    var count = 0
    
    @IBOutlet weak var lockPressed: UIButton!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var historyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyButton.layer.cornerRadius = 10
        
    }
    
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBAction func lockAnimation(_ sender: UIButton) {
        if count == 0 {
            
            // change status
            
            statusLabel.textColor = .green
            statusLabel.text = "Open"
            
            // change image
            
            lockPressed.setImage(#imageLiteral(resourceName: "unlock"), for: UIControlState.normal)
            count = 1
            
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
            
            // mqtt publish
            
            let channel = "Doorlock"
            let message = "unlock"
            let data = message.data(using: .utf8)!
            mqttSession.publish(data, in: channel, delivering: .atMostOnce, retain: false) {
                (succeeded, error) -> Void in
                if succeeded {
                    print("Published!")
                }
            }
            
            // mqtt subscrib
            
            mqttSession.subscribe(to: "Aeng", delivering: .atMostOnce) { (succeeded, error) -> Void in
                if succeeded {
                    print("Subscribed!")
                }
            }
            
         } else {
            
            // change status
            
            statusLabel.textColor = .red
            statusLabel.text = "Close"
            
            //change image
            
            lockPressed.setImage(#imageLiteral(resourceName: "padlock"), for: UIControlState.normal)
            count = 0
            
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
    }
    
    func mqttDidDisconnect(session: MQTTSession) {
        print("Disconnect")
    }
    
    func mqttSocketErrorOccurred(session: MQTTSession) {
        print("SocketError")
    }
    
}

