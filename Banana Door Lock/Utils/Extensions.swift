//
//  Extensions.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/6/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setBottomBorder(borderColor: UIColor) {
        
        // defines the layers shadow
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowColor = borderColor.cgColor
    }
}
