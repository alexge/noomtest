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
    let result: Result<[Food], SearchError>
}

protocol SearchRequestPerformerProtocol {
    func search(_ searchTerm: String, completion: @escaping (SearchResult) -> Void)
}

enum SearchError: Error {
    case tooShort, any, decode, emptyResults
}

class AFConsumer: SearchRequestPerformerProtocol {
    func search(_ searchTerm: String, completion: @escaping (SearchResult) -> Void) {
        let request = AF.request("https://uih0b7slze.execute-api.us-east-1.amazonaws.com/dev/search", method: .get, parameters: ["kv": searchTerm])
        request.response { response in
            switch response.result {
            case .success(let data):
                guard let status = response.response?.statusCode, let data = data else {
                    completion(SearchResult(searchTerm: searchTerm, result: .failure(.any)))
                    return
                }
                
                if 200..<300 ~= status {
                    do {
                        let results = try JSONDecoder().decode([Food].self, from: data)
                        completion(SearchResult(searchTerm: searchTerm, result: .success(results)))
                    } catch {
                        completion(SearchResult(searchTerm: searchTerm, result: .failure(.decode)))
                    }
                } else {
                    if status == 400, let message = try? JSONDecoder().decode(String.self, from: data) {
                        if message.contains("must be at least three characters") {
                            completion(SearchResult(searchTerm: searchTerm, result: .failure(.tooShort)))
                        }
                    } else {
                        completion(SearchResult(searchTerm: searchTerm, result: .failure(.any)))
                    }
                }
            case .failure:
                completion(SearchResult(searchTerm: searchTerm, result: .failure(.any)))
            }
        }
    }
}
