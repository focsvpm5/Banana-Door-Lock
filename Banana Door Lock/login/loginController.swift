//
//  ViewController.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/5/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import UIKit

class loginController: UIViewController {

    
    @IBOutlet weak var logoDoor: UIImageView!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    
    @IBOutlet weak var logIn: UIButton!
    
    @IBOutlet weak var regisTer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.setBottomBorder(borderColor: .white)
        
        passWord.setBottomBorder(borderColor: .white)
        
        logIn.layer.cornerRadius = 10
        
        regisTer.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
    }
    
}

