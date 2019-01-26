//
//  APIManager.swift
//  Onix Test
//
//  Created by Yermakov Anton on 1/3/19.
//  Copyright © 2019 Yermakov Anton. All rights reserved.
//

import Foundation
import Alamofire

class APIManager: APIManagerInterface{
    
    func genericFetch<T: Decodable>(urlString: String, completion: @escaping(T?, APIError?) -> ())  {
        
        Alamofire.request(urlString, method: .get).validate(statusCode: 200..<300).response { response in
            
            guard response.error == nil else {
                completion(nil, APIError.requestFailed)
                return
            }
            
            guard let data = response.data else {
                completion(nil, APIError.invalidData)
                return
            }
            
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(model, nil)
            } catch {
                completion(nil, APIError.jsonParsingFailure)
            }
        }
    }
    
} // class
