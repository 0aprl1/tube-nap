//
//  optionJourneyCell.swift
//  NapTube
//
//  Created by 0aprl1 on 07/09/2019.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class OptionJourneyCell: UITableViewCell {
    
    @IBOutlet weak var linesName: UITextField!
    @IBOutlet weak var numberOfStops: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var departure: UITextField!
    @IBOutlet weak var arrival: UITextField!
    @IBOutlet weak var direction: UITextField!
    @IBOutlet weak var rightLine: UITextView!
    @IBOutlet weak var centralLine: UITextView!
    @IBOutlet weak var leftLine: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
