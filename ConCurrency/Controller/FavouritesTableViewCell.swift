//
//  FavouritesTableViewCell.swift
//  ConCurrency
//
//  Created by Nafea Elkassas on 25/08/2023.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {
       //MARK: - Properties
    var isChecked: Bool = false
    
   //MARK: - Outlets
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var concurrencyCodeLabel: UILabel!
    @IBOutlet weak var currencyRateLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
//        flagImageView.layer.cornerRadius = flagImageView.frame.size.width / 4
        flagImageView.layer.cornerRadius = flagImageView.frame.size.height / 2
//        flagImageView.layer.cornerRadius = 30
        flagImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
