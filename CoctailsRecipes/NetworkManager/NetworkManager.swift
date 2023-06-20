//
//  NetworkManager.swift
//  CoctailsRecipes
//
//  Created by Айдар Оспанов on 20.06.2023.
//

import Foundation

enum Link {
    case coctailURL
    
    var url: URL {
        switch self {
        case .coctailURL:
            return URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita")!
        }
    }
}

enum NetworkError: Error {
    case noData
    case invalidURL
    case decodingError
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCoctail(from url: URL, completion: @escaping(Result<Cocktail, NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No Error Description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let coctail = try decoder.decode(Cocktail.self, from: data)
                completion(.success(coctail))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
    func fetchImage(form urlString: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
            
        }
    }
}
