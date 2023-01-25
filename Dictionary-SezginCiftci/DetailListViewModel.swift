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
    private var searchMeanings = [Meaning]()

    var meanings = [Meaning]()
    
    var sectionWordTypes = WordFilters.allCases
        
    func fetchSearchResult(_ searchText: String, completion: @escaping (Result<[SearchResultModel], NetworkError>) -> ()) {
        guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(searchText)") else { return }
        let resource = Resource<[SearchResultModel]>(url: url)
        service.fetchData(resource: resource) { result in
            switch result {
            case .success(let data):
                self.searchResult = data

                self.searchMeanings = data[0].meanings
                self.meanings = data[0].meanings
                self.sortMeanings(self.searchMeanings)
                
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSectionTitles(_ index: Int) -> String {
        return sectionWordTypes[index].wordFilter ?? ""
    }
    
    func numberOfRowsInSection() -> Int {
        return searchMeanings.count
    }
    
    func cellForRowAt(_ index: Int) -> DetailResultViewModel {
        let result = self.searchResult[index]
        return DetailResultViewModel(searchResult: result)
    }
//
////    func numberOfRowsInSection() -> Int {
////        return searchResult.count
////    } //Lazım değil gibi
    
    func numberOfSections() -> Int {
        return searchMeanings.count
    }
    
    func itemsInSection(_ index: Int) -> Definition {
        let result = self.searchMeanings[index]
        //sortMeanings(DetailViewModel(searchResult: result).meanings)
        return DetailViewModel(searchMeanings: result).definitions[index]
    }
    
    private func sortMeanings(_ meanings: [Meaning]) {
        for meaning in meanings {
            switch meaning.partOfSpeech {
            case WordFilters.Noun.wordFilter?.lowercased():
                addDefinitions(WordFilters.Noun, meaning.definitions)
            case WordFilters.Verb.wordFilter?.lowercased():
                addDefinitions(WordFilters.Verb, meaning.definitions)
            case WordFilters.Adjective.wordFilter?.lowercased():
                addDefinitions(WordFilters.Adjective, meaning.definitions)
            case WordFilters.Adverb.wordFilter?.lowercased():
                addDefinitions(WordFilters.Adverb, meaning.definitions)
            default:
                break
            }
        }
    }
    
    private func addDefinitions(_ wordFilters: WordFilters, _ definitions: [Definition]) {
        for _ in definitions {
            sectionWordTypes.append(wordFilters)
        }
    }
}

struct DetailResultViewModel {
    
    let searchResult: SearchResultModel
    
    var word: String {
        return searchResult.word
    }
    var phonetic: String {
        return searchResult.phonetic
    }
    
    var meanings: [Meaning] {
        return searchResult.meanings
    }
}


struct DetailViewModel {
    
    let searchMeanings: Meaning
    
//    var word: String {
//        return searchResult.word
//    }
//    var phonetic: String {
//        return searchResult.phonetic
//    }
    var definitions: [Definition] {
        return searchMeanings.definitions
    }
}
