//
//  SearchResultModel.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 24.01.2023.
//

import Foundation

// MARK: - SearchResultModel
struct SearchResultModel: Codable {
    let word: String
    let phonetic: String?
    let meanings: [Meaning]
    let sourceUrls: [String]
}

// MARK: - Meaning
struct Meaning: Codable {
    let partOfSpeech: String
    let definitions: [Definition]
}

// MARK: - Definition
struct Definition: Codable {
    let definition: String
    let example: String?
}

// MARK: - Phonetic
struct Phonetic: Codable {
    let text: String?
    let audio: String
    let sourceURL: String?

    enum CodingKeys: String, CodingKey {
        case text, audio
        case sourceURL = "sourceUrl"
    }
}

typealias SearchModel = [SearchResultModel]
