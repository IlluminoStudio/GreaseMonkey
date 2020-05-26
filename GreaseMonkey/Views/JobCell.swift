//
//  JobTableViewCell.swift
//  GreaseMonkey
//
//  Created by user on 29/4/20.
//  Copyright © 2020 Test Co. All rights reserved.
//

import UIKit
import SwipeCellKit

class JobCell: SwipeTableViewCell {

    @IBOutlet weak var tickImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        print("add pressed")
    }
}
