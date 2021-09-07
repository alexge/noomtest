//
//  AFConsumer.swift
//  NoomTest
//
//  Created by Alexander Ge on 07/09/2021.
//

import Alamofire
import Foundation

struct SearchResult {
    let searchTerm: String
    let results: [Food]
}

protocol SearchRequestPerformerProtocol {
    func search(_ searchTerm: String, completion: @escaping (Result<SearchResult, SearchError>) -> Void)
}

enum SearchError: Error {
    case tooShort(String)
    case any(String)
    case decode(String)
}

class AFConsumer: SearchRequestPerformerProtocol {
    func search(_ searchTerm: String, completion: @escaping (Result<SearchResult, SearchError>) -> Void) {
        let request = AF.request("https://uih0b7slze.execute-api.us-east-1.amazonaws.com/dev/search", method: .get, parameters: ["kv": searchTerm])
        request.response { response in
            switch response.result {
            case .success(let data):
                guard let status = response.response?.statusCode, let data = data else {
                    completion(.failure(.any(searchTerm)))
                    return
                }
                
                if 200..<300 ~= status {
                    do {
                        let results = try JSONDecoder().decode([Food].self, from: data)
                        let searchResult = SearchResult(searchTerm: searchTerm, results: results)
                        completion(.success(searchResult))
                    } catch {
                        completion(.failure(.decode(searchTerm)))
                    }
                } else {
                    if status == 400, let message = try? JSONDecoder().decode(String.self, from: data) {
                        if message.contains("must be at least three characters") {
                            completion(.failure(.tooShort(searchTerm)))
                        }
                    } else {
                        completion(.failure(.any(searchTerm)))
                    }
                }
            case .failure:
                completion(.failure(.any(searchTerm)))
            }
        }
    }
}
