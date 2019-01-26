//
//  NBYTableViewCell.swift
//  privatNbyTest
//
//  Created by Yermakov Anton on 1/24/19.
//  Copyright © 2019 Yermakov Anton. All rights reserved.
//

import UIKit

class NBYTableViewCell: UITableViewCell {

    
    @IBOutlet weak var currencyTitle: UILabel!
    @IBOutlet weak var exchangeRate: UILabel!
    
    func setUpCell(with nby: NBY){
        currencyTitle.text = nby.txt
        exchangeRate.text = "\(nby.rate) UAH"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
