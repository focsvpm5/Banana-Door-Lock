//
//  ViewController.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/5/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class loginController: UIViewController, UITextFieldDelegate {

    let realm = try! Realm()
    var users: Results<Account>?
    var user: Account!
    
    
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var logoDoor: UIImageView!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    
    @IBOutlet weak var logIn: UIButton!
    
    @IBOutlet weak var regisTer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.delegate = self
        passWord.delegate = self
        
        loginView.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
        self.users = realm.objects(Account.self)
        
        userName.setBottomBorder(borderColor: .lightGray)
        
        passWord.setBottomBorder(borderColor: .lightGray)
        
        logIn.layer.cornerRadius = 10
        
        regisTer.layer.cornerRadius = 10
        
        setStatusBarBackgroundColor(color: .init(red: 65/255.0, green: 195/255.0, blue: 0, alpha: 1))
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        let parameters: Parameters = ["username": "\(userName.text!)", "password": "\(passWord.text!)"]
        let baseURL = "http://b-gib.banana.co.th/Smarthome/public/login"
        let header = ["Apikey": "banana_app_iot", "Content-Type": "application/x-www-form-urlencoded"]
        print(parameters)
        Alamofire.request(baseURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                //debugPrint(response)
                //print(response.description)
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    //print(JSON)
                    
                    let message = JSON["message"] as! Dictionary<String,String>
                    let userId = message["userId"]
                    let firstName = message["firstName"]
                    let lastName = message["lastName"]
                    let gender = message["gender"]
                    let addr = message["addr"]
                    let tel = message["tel"]
                    let email = message["email"]
                    let imgUrl = message["imgUrl"]
                    let token = message["token"]
                    let userType = message["userType"]
                    let account = Account(_userId: userId!, _firstName: firstName!, _lastName: lastName!, _gender: gender!, _addr: addr!, _tel: tel!, _email: email!, _imgUrl: imgUrl!, _token: token!, _userType: userType!)
                    print(account)
                    RealmService.share.create(account)
                }
        }
    }
    
}

