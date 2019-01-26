//
//  PrivateTableViewCell.swift
//  privatNbyTest
//
//  Created by Yermakov Anton on 1/23/19.
//  Copyright © 2019 Yermakov Anton. All rights reserved.
//

import UIKit

class PrivateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var buyLbl: UILabel!
    @IBOutlet weak var saleLbl: UILabel!
    
    func setUpCell(with privat: Privat){
        currencyLbl.text = privat.ccy
        buyLbl.text = privat.buy
        saleLbl.text = privat.sale
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
