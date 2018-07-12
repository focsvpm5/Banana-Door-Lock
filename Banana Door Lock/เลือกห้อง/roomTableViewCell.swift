//
//  roomTableViewCell.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/11/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import UIKit

class roomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var greenView: UIView!
    
    @IBOutlet weak var numberRoom: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        greenView.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withViewModel viewModel: Account) -> (Void) {
        
        numberRoom.text = viewModel.userId
        
    }

    
}
