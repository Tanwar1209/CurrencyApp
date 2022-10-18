//
//  OtherCurrencyDataTableViewCell.swift
//  CurrencyApp
//
//  Created by Tarun Tanwar on 17/10/22.
//

import UIKit

class OtherCurrencyDataTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    public var cellModel: CurrencyModel! {
        didSet {
            self.titleLabel.text = cellModel.currencySymbol + StringConstants.epsilonString + cellModel.currencyValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = StringConstants.emptyString
    }
}
