//
//  selectedRoomViewController.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/11/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class selectedRoomViewController: UIViewController {

    // Realm
    let realm = try! Realm()
    var items : Results<selectedRoom>?
    var item:selectedRoom!
    
    @IBOutlet weak var haveRoomLabel: UILabel!
    
    @IBOutlet weak var logOut: UIButton!
    
    @IBOutlet weak var tableViewRoom: UITableView!
    
    let identifier = "roomCellIdentifier"
    
    // selected Room API
    var success = "success"
    
    var tokenWithUserDoor : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userDoorlock = realm.objects(userDoor.self).last {
            self.tokenWithUserDoor = userDoorlock.token
            print("Token is : \(tokenWithUserDoor)")
        }
        
        
        
        selectedRoomAPI {
            // Realm
            self.items = self.realm.objects(selectedRoom.self)
            
            self.haveRoomLabel.text = "\(self.items!.count)"
            self.tableViewRoom.reloadData()
        }
        
        let nib = UINib(nibName: "roomTableViewCell", bundle: nil)
        
        tableViewRoom.register(nib, forCellReuseIdentifier: identifier)
        
        logOut.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        let loginView = storyboard?.instantiateViewController(withIdentifier: "loginController")as! loginController
        present(loginView, animated: true, completion: nil)
    }
    
    // API selected Room
    func selectedRoomAPI (completetion : @escaping () -> ()) {
        
        // Realm
        self.items = realm.objects(selectedRoom.self)
        try! realm.write {
            realm.delete(items!)
        }
        
        let baseURL = "http://january.banana.co.th/api/user/room"
        //let header = ["Apikey": "banana_app_iot", "Content-Type": "application/x-www-form-urlencoded"]
        let header = ["token": "\(tokenWithUserDoor)"]
        Alamofire.request(baseURL, method: .get, encoding: URLEncoding.default, headers: header)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                //print(response.description)
                if let result = response.result.value {
                    
                    let JSON = result as! NSDictionary
                    let status = JSON["status"] as! String
                    if status == self.success {
                        let messageData = JSON["message"] as? [[String:String]]
                        let localArray = messageData
                        print("Local Array:", localArray!)
                        for i in 0..<localArray!.count {
                            let dic = localArray![i]
                            let room_id = dic["room_id"]
                            print(room_id!)
                            let numberRoom = selectedRoom(_room_id: room_id!)
                            print(numberRoom)
                            RealmService.share.create(numberRoom)
                        }
                    } else {
                        print(status)
                        //self.displayAlertDialog(with: "Failed", and: "\(status)", dismiss: false)
                    }
                }
                completetion()
        }
    }
    
    func displayAlertDialog(with title: String, and message: String, dismiss: Bool){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var okHandler = { (action: UIAlertAction) -> Void in}
        
        if dismiss {
            okHandler = { (action: UIAlertAction) -> Void in
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: okHandler)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension selectedRoomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? roomTableViewCell
        
        let data = self.items![indexPath.row]
        
        cell?.configure(withViewModel: data)
        
        return cell!
    }
}

extension selectedRoomViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        
        tableViewRoom.reloadData()
        let userView = storyboard?.instantiateViewController(withIdentifier: "userController")as! userController
        let userSelect = self.items![indexPath.row]
        userView.selectToRoom = userSelect
        //present(userView, animated: true, completion: nil)
        self.navigationController?.pushViewController(userView, animated: true)
    }
    
}

