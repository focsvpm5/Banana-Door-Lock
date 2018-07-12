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

class registerController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
    
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var ชื่อText: UITextField!
    @IBOutlet weak var นามสกุลText: UITextField!
    @IBOutlet weak var เบอร์โทรText: UITextField!
    
    
    @IBOutlet weak var ตำแหน่งText: UITextField!
    var ตำแหน่ง = ["Student","Teacher","TA"]
    var selectedPosition: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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





