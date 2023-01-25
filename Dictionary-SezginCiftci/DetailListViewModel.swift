//
//  DetailViewModel.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 24.01.2023.
//

import Foundation

class DetailListViewModel {
    
    private let service = Network()
    private var searchResult = [SearchResultModel]()
        
    func fetchSearchResult(_ searchText: String, completion: @escaping (Result<[SearchResultModel], NetworkError>) -> ()) {
        guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(searchText)") else { return }
        let resource = Resource<[SearchResultModel]>(url: url)
        service.fetchData(resource: resource) { result in
            switch result {
            case .success(let data):
                self.searchResult = data
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cellForRowAt(_ index: Int) -> DetailViewModel {
        let result = self.searchResult[index]
        return DetailViewModel(searchResult: result)
    }
    
    func numberOfRowsInSection() -> Int {
        return searchResult.count
    }
}

struct DetailViewModel {
    
    let searchResult: SearchResultModel
    
    var word: String {
        return searchResult.word
    }
    var phonetic: String {
        return searchResult.phonetic
    }
}
