//
//  RandomUserTableViewCell.swift
//  SimpleRest
//
//  Created by Benjamin Cortens on 2015-11-01.
//  Copyright © 2015 Benjamin Cortens. All rights reserved.
//

import UIKit

class RandomUserTableViewCell: UITableViewCell {

	//	MARK: Properties
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var thumbnailPhoto: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
