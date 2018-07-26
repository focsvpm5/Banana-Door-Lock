//
//  registerController.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/5/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

//
//  ViewController.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/5/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import UIKit
import SwiftValidator
import Alamofire
import FirebaseStorage

class registerController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ValidationDelegate {
    
    // Api register
    var registersuccess = "success"
    
    // Firebase storage
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    var imageURL: String = ""
    
    // UI ImageView
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            //After it is complete
        }
    }
    
    // UI TextFied
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var ชื่อText: UITextField!
    @IBOutlet weak var นามสกุลText: UITextField!
    @IBOutlet weak var เบอร์โทรText: UITextField!
    @IBOutlet weak var ตำแหน่งText: UITextField!
    var ตำแหน่ง = ["student","mentor"]
    var selectedPosition: String?
    
    // UI Label
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var firstnameError: UILabel!
    @IBOutlet weak var lastnameError: UILabel!
    @IBOutlet weak var telError: UILabel!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        validator.registerField(emailText, errorLabel: emailError, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordText, errorLabel: passwordError, rules: [RequiredRule()])
        validator.registerField(ชื่อText, errorLabel: firstnameError, rules: [RequiredRule(),firstLastNameRule()])
        validator.registerField(นามสกุลText, errorLabel: lastnameError, rules: [RequiredRule(),firstLastNameRule()])
        validator.registerField(เบอร์โทรText, errorLabel: telError, rules: [RequiredRule(), PhoneNumberRule()])
        
        emailText.setBottomBorder(borderColor: .lightGray)
        passwordText.setBottomBorder(borderColor: .lightGray)
        ชื่อText.setBottomBorder(borderColor: .lightGray)
        นามสกุลText.setBottomBorder(borderColor: .lightGray)
        เบอร์โทรText.setBottomBorder(borderColor: .lightGray)
        ตำแหน่งText.setBottomBorder(borderColor: .lightGray)
        
        emailText.delegate = self
        passwordText.delegate = self
        ชื่อText.delegate = self
        นามสกุลText.delegate = self
        เบอร์โทรText.delegate = self
        ตำแหน่งText.delegate = self
        
        positionPicker()
        createToolbar()
        
        ตำแหน่งText.rightViewMode = .always
        let imageviewtext = UIImageView()
        imageviewtext.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        let imagetext = #imageLiteral(resourceName: "drop-down-arrow")
        imageviewtext.image = imagetext
        ตำแหน่งText.rightView = imageviewtext
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    class firstLastNameRule: RegexRule {
        
        static let regex = "[A-Za-z]{1,}"
        
        convenience init(message : String = "Not a english"){
            self.init(regex: firstLastNameRule.regex, message : message)
        }
    }
    
    @IBAction func donePressed(_ sender: AnyObject) {
        print("Validating...")
        validator.validate(self)
    }
    
    func validationSuccessful() {
        print("Validation Success!")
        
        upImageFirebase {
            self.registerAPI {
                let loginView = self.storyboard?.instantiateViewController(withIdentifier: "loginController")as! loginController
                self.present(loginView, animated: true, completion: nil)
            }
        }
        
        
//        let alert = UIAlertController(title: "Success", message: "สมัครเรียบร้อยแล้ว", preferredStyle: UIAlertControllerStyle.alert)
//        //let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(defaultAction)
//        self.present(alert, animated: false, completion: nil)
        
        //dismiss(animated: true, completion: nil)
    }
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {
        print("Validation FAILED!")
    }
    
    // Upload image to Firebase
    func upImageFirebase (completetion : @escaping () -> ()) {
        // Firebase
        guard let image = myImageView.image else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 1) else { return }
        let uploadImageRef = imageReference.child("\(ชื่อText.text!) \(นามสกุลText.text!).jpg")
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print("UPLOAD TASK FINISHED")
            print(metadata ?? "NO METADATA")
            print(error ?? "NO ERROR")
            uploadImageRef.downloadURL { (url, error) in
                let urlText = url?.absoluteString
                //print(urlText)
                print(url ?? "NO URL")
                print(error ?? "NO ERROR")
                self.imageURL = urlText!
            }
        }
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        uploadTask.resume()
        completetion()
    }
    
    // Register API
    func registerAPI (completetion : @escaping () -> ()) {
        
        let parameters: Parameters = ["user": "\(emailText.text!)", "pass": "\(passwordText.text!)", "firstname": "\(ชื่อText.text!)", "lastname": "\(นามสกุลText.text!)", "user_role": "\(ตำแหน่งText.text!)", "tel": "\(เบอร์โทรText.text!)", "picture": "\(imageURL)"]
        let baseURL = "http://january.banana.co.th/api/auth/regis"
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
                debugPrint(response)
                //print(response.description)
                if let result = response.result.value {
                    
                    let JSON = result as! NSDictionary
                    let status = JSON["status"] as! String
                    if status == self.registersuccess {
                        print(self.registersuccess)
                        completetion()
                    } else {
                        print(status)
                        self.displayAlertDialog(with: "Register Failed", and: "already user", dismiss: false)
                    }
                }
        }
    }
    
    // Alert
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
    
    // ดึงรูป
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            myImageView.image = image
            
        }
        else
        {
            //Error message
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func positionPicker() {
        let positionPicker = UIPickerView()
        positionPicker.delegate = self
        ตำแหน่งText.inputView = positionPicker
        
        //Customizations
        positionPicker.backgroundColor = .white
        
    }
    
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //Customizations
        toolBar.barTintColor = .init(red: 97/255.0, green: 216/255.0, blue: 0, alpha: 1)
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(registerController.dismissKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        ตำแหน่งText.inputAccessoryView = toolBar
    }
    
    // keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension registerController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ตำแหน่ง.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ตำแหน่ง[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedPosition = ตำแหน่ง[row]
        ตำแหน่งText.text = selectedPosition
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Menlo-Regular", size: 17)
        
        label.text = ตำแหน่ง[row]
        
        return label
    }
    
}




