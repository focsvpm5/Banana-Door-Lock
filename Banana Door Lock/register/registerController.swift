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

class registerController: UIViewController {
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var ชื่อText: UITextField!
    @IBOutlet weak var นามสกุลText: UITextField!
    @IBOutlet weak var เบอร์โทรText: UITextField!
    @IBOutlet weak var ตำแหน่งText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailText.setBottomBorder(borderColor: .white)
        usernameText.setBottomBorder(borderColor: .white)
        passwordText.setBottomBorder(borderColor: .white)
        ชื่อText.setBottomBorder(borderColor: .white)
        นามสกุลText.setBottomBorder(borderColor: .white)
        เบอร์โทรText.setBottomBorder(borderColor: .white)
        ตำแหน่งText.setBottomBorder(borderColor: .white)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
}


