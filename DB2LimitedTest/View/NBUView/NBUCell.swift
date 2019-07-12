//
//  NBUCell.swift
//  DB2LimitedTest
//
//  Created by md760 on 7/11/19.
//  Copyright © 2019 md760. All rights reserved.
//

import UIKit

final class NBUCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currencyRateNBLabel: UILabel!
    @IBOutlet weak var forUAHRateNBLabel: UILabel!

    var model: NBUExchangeRateModel? {
        didSet {
            guard let data = model,
            let baseCurrency = data.baseCurrency,
            let currency = data.currency
            else { return }
            titleLabel.text = data.currency
            currencyRateNBLabel.text = String(data.purchaseRateNB?.rounded(toPlaces: 2) ?? 0.0) + baseCurrency
            forUAHRateNBLabel.text = "1\(currency)"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = selected ? #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
    
}
