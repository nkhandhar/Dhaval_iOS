//
//  SearchTableViewCell.swift
//  TestProject
//
//  Created by Saavaj on 24/12/18.
//  Copyright © 2018 Saavaj. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    
    // MARK:-  Outlets
    
    @IBOutlet weak var lblCreatedAt: UILabel!
    @IBOutlet weak var switchActivate: UISwitch!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
