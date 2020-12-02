//
//  DBViewController.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 17.11.20.
//

import UIKit


class DBViewController<T: Decodable>: UIViewController {
    

    var storage: [T] = []
    var specialStorage: [T] = []
    
    func insert(by id: Int, table: PrivateHealthCareFacilityEndpoint.TableName, completion: @escaping () -> ()) {
        NetworkEngine.request(endpoint: PrivateHealthCareFacilityEndpoint.create(name: table, id: id)) { (result: Result<[T], Error>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let success):
                let one = success.first!
                self.storage.append(one)
                completion()
            }
        }
    }
    
    func delete(table: PrivateHealthCareFacilityEndpoint.TableName, by id: Int) {
        NetworkEngine.request(endpoint: PrivateHealthCareFacilityEndpoint.delete(name: table, id: id)) { (result: Result<[Specialization], Error>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let success):
                print(success)
            }
        }
    }
    
    func getAll(table: PrivateHealthCareFacilityEndpoint.TableName, completion: @escaping () -> ()) {
        NetworkEngine.request(endpoint: PrivateHealthCareFacilityEndpoint.getAllFrom(searched: table)) { (result: Result<[T], Error>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let success):
                self.specialStorage = success
                self.storage = success
                completion()
                print(success)
            }
        }
    }
    
    
    
}
