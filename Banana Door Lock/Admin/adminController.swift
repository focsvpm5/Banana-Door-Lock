//
//  adminController.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/7/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import UIKit
import SideMenu

class adminController: UIViewController {
    
    @IBOutlet weak var ดูประวัติ: UIButton!
    
    var count = 0
    
    @IBOutlet weak var lockPressed: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ดูประวัติ.layer.cornerRadius = 10
        
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func lockAnimation(_ sender: UIButton) {
        
        if count == 0 {
            lockPressed.setImage(#imageLiteral(resourceName: "unlock"), for: UIControlState.normal)
            count = 1
        } else {
            lockPressed.setImage(#imageLiteral(resourceName: "padlock"), for: UIControlState.normal)
            count = 0
        }
        
    }
    
}
