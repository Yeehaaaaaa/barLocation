//
//  BarTableViewCell.swift
//  barLocation
//
//  Created by Arthur Daurel on 28/05/16.
//  Copyright © 2016 Arthur Daurel. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell
import MapKit

class BarTableViewCell: FoldingCell {
    
    @IBOutlet var barTitle: UILabel!
    @IBOutlet weak var barName: UILabel!
    @IBOutlet weak var barImageView: UIImageView!
    @IBOutlet var address: UILabel!
    @IBOutlet var barTags: UILabel!
    @IBOutlet weak var barButton: UIButton!
    
    override func awakeFromNib() {
        
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
}