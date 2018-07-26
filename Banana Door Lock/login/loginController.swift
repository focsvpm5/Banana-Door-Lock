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
import SwiftValidator

class loginController: UIViewController, UITextFieldDelegate, ValidationDelegate {
    
    // Api Login
    var loginsuccess = "Login Success"

    // Realm
    let realm = try! Realm()
    var users: Results<userDoor>?
    var user: userDoor!
    
    // UI View
    @IBOutlet weak var loginView: UIView!
    
    // UI Image View
    @IBOutlet weak var logoDoor: UIImageView!
    
    // Text Field
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    
    // Button
    @IBOutlet weak var logIn: UIButton!
    @IBOutlet weak var regisTer: UIButton!
    
    // Label
    @IBOutlet weak var usernameError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    
    // Validate
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Validate
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
                
            }
        }, error:{ (validationError) -> Void in
            print("error")
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.field as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            }
        })
        
        validator.registerField(userName, errorLabel: usernameError, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passWord, errorLabel: passwordError, rules: [RequiredRule()])
        
        userName.delegate = self
        passWord.delegate = self
        
        loginView.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
        self.users = realm.objects(userDoor.self)
        
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
        
        print("Validating...")
        validator.validate(self)
        
        
    }
    
    // Validate
    func validationSuccessful() {
        print("Validation Success!")
        
        // Realm
        self.users = realm.objects(userDoor.self)
        try! realm.write {
            realm.delete(users!)
        }
        
        loginAPI {
            let selectRoomView = self.storyboard?.instantiateViewController(withIdentifier: "selectedRoomViewController")as! UINavigationController
            self.present(selectRoomView, animated: true, completion: nil)
        }
//        let alert = UIAlertController(title: "Success", message: "สมัครเรียบร้อยแล้ว", preferredStyle: UIAlertControllerStyle.alert)
//        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(defaultAction)
//        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {
        print("Validation FAILED!")
    }
    
    // Login API
    func loginAPI (completetion : @escaping () -> ()) {
        let parameters: Parameters = ["user": "\(userName.text!)", "pass": "\(passWord.text!)"]
        let baseURL = "http://january.banana.co.th/api/auth/login"
        //let header = ["Apikey": "banana_app_iot", "Content-Type": "application/x-www-form-urlencoded"]
        let header = ["Content-Type": "application/x-www-form-urlencoded"]
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
                //                guard let newsResponse = response.result.value as? [[String:String]] else{
                //                    print("Error: \(String(describing: response.result.error))")
                //                    return
                //                }
                //                print("JSON: \(newsResponse)")
                //                let localArray = newsResponse
                //                //Access the localArray
                //                //print("Local Array:", localArray)
                //                //Now to get the desired value from dictionary try like this way.
                //                let dic = localArray[0]
                //                let token = dic["token"]
                //                let firstname = dic["firstname"]
                //                let lastname = dic["lastname"]
                //                let user_id = dic["user_id"]
                //                let userData = userRealm(_token: token!, _firstName: firstname!, _lastName: lastname!, _userId: user_id!)
                //                print(userData)
                //                RealmService.share.create(userData)
                //... get other value same way.
                debugPrint(response)
                //print(response.description)
                if let result = response.result.value {
                    
                    let JSON = result as! NSDictionary
                    let status = JSON["status"] as! String
                    if status == self.loginsuccess {
                        let message = JSON["message"] as! Dictionary<String,String>
                        let token = message["token"]
                        let firstName = message["firstname"]
                        let lastName = message["lastname"]
                        let user_id = message["user_id"]
                        let userRole = message["user_role"]
                        let picture = message["picture"]
                        let userData = userDoor(_token: token!, _firstName: firstName!, _lastName: lastName!, _userId: user_id!, _userRole: userRole!, _picture: picture!)
                        print(userData)
                        RealmService.share.create(userData)
                        completetion()
                    } else {
                        print(status)
                        self.displayAlertDialog(with: "Login Failed", and: "Wrong Username or Password", dismiss: false)
                    }
                    
                }
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
    
}

