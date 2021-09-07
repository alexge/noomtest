//
//  AFConsumer.swift
//  NoomTest
//
//  Created by Alexander Ge on 07/09/2021.
//

import Alamofire
import Foundation

class AFConsumer {
    func search(_ searchTerm: String) {
        let request = AF.request("https://uih0b7slze.execute-api.us-east-1.amazonaws.com/dev/search", method: .get, parameters: ["kv": searchTerm])
        request.response { response in
            switch response.result {
            case .success(let data):
                guard let status = response.response?.statusCode, let data = data else {
                    print("Something went wrong")
                    return
                }
                
                if 200..<300 ~= status {
                    do {
                        let results = try JSONDecoder().decode([Food].self, from: data)
                        print(results)
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    if status == 400 {
                        let message = try? JSONDecoder().decode(String.self, from: data)
                        print(message)
                    } else {
                        print("Something went wrong")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
