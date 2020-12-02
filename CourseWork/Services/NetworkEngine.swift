//
//  NetworkEngine.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 15.11.20.
//

import Foundation


protocol NetworkEngineProtocol: class {
    static func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<[T], Error>) -> ())
}

class NetworkEngine: NetworkEngineProtocol {
    
    class func request<T>(endpoint: Endpoint, completion: @escaping (Result<[T], Error>) -> ()) where T : Decodable {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        guard let url = components.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        let session = URLSession(configuration: .default)
        let _ = session.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "unknown error")
                return
            }
            
            guard response != nil, let data = data else { return }
            
            DispatchQueue.main.async {
                do {
                    let responseObject = try JSONDecoder().decode([T].self, from: data)
                    completion(.success(responseObject))
                    
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("could not find key \(key) in JSON: \(context.debugDescription)")
                } catch DecodingError.valueNotFound(let type, let context) {
                    print("could not find type \(type) in JSON: \(context.debugDescription)")
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                } catch DecodingError.dataCorrupted(let context) {
                    print("data found to be corrupted in JSON: \(context.debugDescription)")
                } catch let error as NSError {
                    completion(.failure(error))
                    NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                }

            }
            
        }.resume()
    }
    
    
}
