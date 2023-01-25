//
//  FooterCollectionViewCell.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 24.01.2023.
//

import UIKit

class FooterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var synonymLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.borderWidth = 0.2
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 16
    }
}
