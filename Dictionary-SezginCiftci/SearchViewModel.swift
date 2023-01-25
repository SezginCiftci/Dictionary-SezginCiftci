//
//  SearchViewModel.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 24.01.2023.
//

import Foundation

class SearchViewModel {
    
    let userDefaults = UserDefaults.standard
    
    func saveSearchText(_ searchTexts: [String]) {
        userDefaults.set(searchTexts, forKey: "searchTexts")
    }
    
    func getSearchedTexts() -> [String] {
        userDefaults.object(forKey: "searchTexts") as? [String] ?? []
    }
}

