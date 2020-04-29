//
//  CarCell.swift
//  GreaseMonkey
//
//  Created by Jialin Wang on 28/4/20.
//  Copyright © 2020 Test Co. All rights reserved.
//

import UIKit
import Charts
import SwipeCellKit

class CarCell: SwipeTableViewCell {
    
    @IBOutlet weak var regoLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var pieChartView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
