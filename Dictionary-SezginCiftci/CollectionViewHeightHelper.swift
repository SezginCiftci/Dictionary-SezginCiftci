//
//  CollectionViewHeightHelper.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 25.01.2023.
//

import UIKit

class CollectionViewCellHeightHelper {
    func generateCellHeight(_ descriptionText: String, _ exampleText: String?) -> CGFloat {
        if let exampleText = exampleText {
            switch descriptionText.count + (exampleText.count) {
            case 0...250:
                return 150
            case 251...350:
                return 200
            case 351...:
                return 250
            default:
                return 150
            }
        } else {
            return 90
        }
    }
}
