//
//  TransformerService.swift
//  Transformers
//
//  Created by Alek Spitzer on 3/27/21.
//

import Foundation

/// Class TransformerService handling Transformer CRUD methods to the backend
class TransformerService {
    let authorizationKey = "authorizationKey"
    let baseURL = "https://transformers-api.firebaseapp.com/transformers"
    
    typealias GetTansformersCompletionHandler = (_ transformersReponse:TransformersResponse?) -> Void
    typealias SuccessCompletionHandler = (_ success:Bool?) -> Void
    
    
    func retrieveAndStoreAuthorizationToken() {
        
        if let _ = UserDefaults.standard.string(forKey: authorizationKey) {
            return
        }
        
        
        let url = URL(string: "https://transformers-api.firebaseapp.com/allspark")
        guard let requestUrl = url else { return }
        
        let request = URLRequest(url: requestUrl)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                UserDefaults.standard.set(dataString, forKey: self.authorizationKey)
            }
        }
        
        task.resume()
    }
    
    // MARK: Create
    
    /// Manages the creation of the transformer object
    /// - Parameters:
    ///   - transformer: The transformer object
    ///   - completion: The completion handler indicating success or failure
    func createTransformer(transformer: Transformer, completion: @escaping SuccessCompletionHandler)  {
        let url = URL(string: baseURL)
        guard let requestUrl = url else {
            return
            
        }

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = allHTTPHeaderFields()
        
        do {
            let data = try JSONEncoder().encode(transformer)
            request.httpBody = data

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error)
                    completion(false)
                    return
                }

                if let data = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let transformer = try jsonDecoder.decode(Transformer.self, from: data)
                        print("Transformer created with success: \(transformer)")
                        completion(true)

                    } catch let error{
                        completion(false)
                        print(error)
                    }
                }
            }
            
            task.resume()
            
        } catch let error{
            completion(false)
            print(error)
        }
    }
    
    // MARK: - Read
    
    /// Manages fetching of the transformer objects
    /// - Parameter completion: The completion handler returning transformers from the service
    func getTransformers(completion: @escaping GetTansformersCompletionHandler) {
        let url = URL(string: baseURL)
        guard let requestUrl = url else {
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = allHTTPHeaderFields()
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let transformerResponse = try jsonDecoder.decode(TransformersResponse.self, from: data)
                    completion(transformerResponse)
                    

                } catch let error{
                    completion(nil)
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Update
    
    /// Manages the update of the transformer object
    /// - Parameters:
    ///   - transformer: The transformer object
    ///   - completion: The completion handler indicating success or failure
    func updateTransformer(transformer: Transformer, completion: @escaping SuccessCompletionHandler)  {
        let url = URL(string: baseURL)
        guard let requestUrl = url else {
            return
            
        }

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = allHTTPHeaderFields()
        
        do {
            let data = try JSONEncoder().encode(transformer)
            request.httpBody = data

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error)
                    completion(false)
                    return
                }

                if let data = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let transformer = try jsonDecoder.decode(Transformer.self, from: data)
                        print("Transformer updated with success: \(transformer)")
                        completion(true)

                    } catch let error{
                        completion(false)
                        print(error)
                    }
                }
            }
            
            task.resume()
            
        } catch let error{
            completion(false)
            print(error)
        }
    }
    
    // MARK: - Delete
    
    /// Manages the deletion of the transformer object
    /// - Parameters:
    ///   - transformer: The transformer object
    ///   - completion: The completion handler indicating success or failure
    func deleteTransformer(transformer: Transformer, completion: @escaping SuccessCompletionHandler)  {
        let url = URL(string: baseURL + "/\(transformer.id)")
        guard let requestUrl = url else {
            return
            
        }

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = allHTTPHeaderFields()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, let _ = data
            else {
                completion(false)
                print("error: not a valid http response")
                return
            }
            
            if (200 ..< 299).contains(httpResponse.statusCode) {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    
    // MARK: - Helper Methods
    
    private func allHTTPHeaderFields() -> [String: String]? {
        guard let authorizationToken = UserDefaults.standard.string(forKey: authorizationKey) else {
            return nil
        }
        
        let headerFields = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(authorizationToken)"
        ]
        return headerFields
    }
}
    
    
    
    
