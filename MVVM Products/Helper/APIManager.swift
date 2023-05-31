//
//  APIManager.swift
//  MVVM Products
//
//  Created by Sadia on 28/5/23.
//

import Foundation
import UIKit

enum DataError: Error{
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
}

final class APIManager{
    static let shared = APIManager()
    private init () {}
    
    typealias Handler = ((Result<[Product], DataError>)-> Void)
    
    func fetchProduct(completion: @escaping Handler) {
        guard let url = URL(string:Constant.API.productURL ) else{
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else{
                completion(.failure(.invalidResponse))
                return
            }
            do{
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(products))
            }catch{
                completion(.failure(.network(error)))
            }
                      
        } .resume()
    }
    
    
    
}
