//
//  SynonymResultModel.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 24.01.2023.
//

import Foundation

 struct SynonymResultModel: Codable {
    let word: String
    let score: Int
}

typealias SynonymModel = [SynonymResultModel]
