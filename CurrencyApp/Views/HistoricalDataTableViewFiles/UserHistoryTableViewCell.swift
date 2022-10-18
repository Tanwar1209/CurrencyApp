//
//  UserHistoryTableViewCell.swift
//  CurrencyApp
//
//  Created by Tarun Tanwar on 17/10/22.
//

import UIKit

class UserHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    public var cellModel: HistoricalDataModel! {
        didSet {
            self.dateLabel.text = StringConstants.onKey + StringConstants.emptySpaceString + cellModel.dateString
            self.valueLabel.text = cellModel.fromCurrencyValue + StringConstants.emptySpaceString + cellModel.fromCurrencySymbol + StringConstants.epsilonString + cellModel.toCurrencyValue + StringConstants.emptySpaceString + cellModel.toCurrencySymobl
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
        dateLabel.text = StringConstants.emptyString
        valueLabel.text = StringConstants.emptyString
    }
}
