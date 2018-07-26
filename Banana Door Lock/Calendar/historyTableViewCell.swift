//
//  historyTableViewCell.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/23/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import UIKit

class historyTableViewCell: UITableViewCell {

    // Label
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withRealm realm: historyDate) -> (Void) {
        
        firstName.text = realm.firstName
        lastName.text = realm.lastName
        time.text = realm.date
        
    }
    
}
