//
//  Endpoint.swift
//  Lab9
//
//  Created by IvanLyuhtikov on 2.11.20.
//

import Foundation


protocol Endpoint {
    
    var scheme: String { get }
    
    var baseURL: String { get }
    
    var path: String { get }
    
    var parameters: [URLQueryItem] { get }
    
    var method: String { get }
}
