//
//  PBCell.swift
//  DB2LimitedTest
//
//  Created by md760 on 7/11/19.
//  Copyright © 2019 md760. All rights reserved.
//

import UIKit

final class PBCell: UITableViewCell {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var purchaseRateLabel: UILabel!
    @IBOutlet weak var saleRateLabel: UILabel!
    
    var model: PrivatBankModel? {
        didSet {
            guard let data = model else { return }
            currencyLabel.text = data.currency
            purchaseRateLabel.text = String(data.purchaseRate ?? 0.0)
            saleRateLabel.text = String(data.saleRate ?? 0.0)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = selected ? #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
}
