//
//  selectedRoomViewController.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/11/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import UIKit
import RealmSwift

class selectedRoomViewController: UIViewController {

    
    
    @IBOutlet weak var logOut: UIButton!
    
    @IBOutlet weak var tableViewRoom: UITableView!
    
    let identifier = "roomCellIdentifier"
    
    var rooms : Results<Account>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "roomTableViewCell", bundle: nil)
        
        tableViewRoom.register(nib, forCellReuseIdentifier: identifier)
        
        logOut.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        let loginView = storyboard?.instantiateViewController(withIdentifier: "loginController")as! loginController
        present(loginView, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? roomTableViewCell
        
        //let data = self.rooms![indexPath.row]
        
        //cell?.configure(withViewModel: data)
        
        return cell!
    }
}

extension selectedRoomViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        //performSegue(withIdentifier: "updateMa", sender: self)
//        let updateView = storyboard?.instantiateViewController(withIdentifier: "UpdateController")as! UpdateController
//        let pickUp = self.items![indexPath.row]
//        updateView.pickup = pickUp
        //present(updateView, animated: true, completion: nil)
        tableViewRoom.reloadData()
    }
    
}

