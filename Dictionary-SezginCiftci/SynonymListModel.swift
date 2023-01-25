//
//  SynonymListViewModel.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 25.01.2023.
//

import Foundation

class SynonymViewListModel {
    
    private let service = Network()
    private var synonymResult = [SynonymResultModel]()
    
    func fetchSynonymResult(_ searchText: String, completion: @escaping (Result<[SynonymResultModel], NetworkError>) -> ()) {
        guard let url = URL(string: "https://api.datamuse.com/words?rel_syn=\(searchText)") else { return }
        let resource = Resource<[SynonymResultModel]>(url: url)
        service.fetchData(resource: resource) { result in
            switch result {
            case .success(let data):
                self.synonymResult = self.handleScores(data)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func synonymResults() -> [String] {
        return synonymResult.map { $0.word }
    }
    
    private func handleScores(_ synonyms: [SynonymResultModel]) -> [SynonymResultModel] {
        let sortedSynonyms = synonyms.sorted { $0.score > $1.score}
        var returnSynonyms = [SynonymResultModel]()
        for (index, syn) in sortedSynonyms.enumerated() where index < 5 {
            returnSynonyms.append(syn)
        }
        return returnSynonyms
    }
}

struct SynonymViewModel {
    
    let synonymResult: SynonymResultModel
    
    var word: String {
        return synonymResult.word
    }
    var phonetic: Int {
        return synonymResult.score
    }
}
