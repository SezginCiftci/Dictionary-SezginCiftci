//
//  DetailListViewModel.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 24.01.2023.
//

import Foundation

class DetailListViewModel {
    
    private let service = WebService()
    private var searchResult = [SearchResultModel]()
    var meanings = [Meaning]()
            
    func fetchSearchResult(_ searchText: String, completion: @escaping (Result<[SearchResultModel], NetworkError>) -> ()) {
        guard let url = URL(string: "\(ApiConstants.searchUrl)\(searchText)") else { return }
        let resource = Resource<[SearchResultModel]>(url: url)
        service.fetchData(resource: resource) { result in
            switch result {
            case .success(let data):
                self.searchResult = data
                self.meanings = data[0].meanings
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return meanings.count
    }
    
    func cellForRowAt(_ index: Int) -> DetailHeaderViewModel {
        let result = self.searchResult[index]
        return DetailHeaderViewModel(searchResult: result)
    }
    
}

