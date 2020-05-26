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
//class CarCell: UITableViewCell {
    
    @IBOutlet weak var regoLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var pieChartView: UIView!
    @IBOutlet weak var flagImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 5)
        
//        messageLabel.font = .preferredFont(forTextStyle: .body)
//        messageLabel.adjustsFontForContentSizeCategory = true
        
        //messageLabel.font = messageLabel.font.withSize(28)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //backgroundColor = selected ? .red : .green
    }
    
}
