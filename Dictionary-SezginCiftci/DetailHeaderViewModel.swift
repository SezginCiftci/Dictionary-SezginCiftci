//
//  DetailHeaderViewModel.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 25.01.2023.
//

import Foundation

struct DetailHeaderViewModel {
    
    let searchResult: SearchResultModel
    
    var word: String {
        return searchResult.word
    }
    var phonetic: String {
        return searchResult.phonetic ?? ""
    }
}
