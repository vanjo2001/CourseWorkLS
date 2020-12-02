//
//  PrivateHealthCareFacilityEndpoint.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 15.11.20.
//

import Foundation

enum PrivateHealthCareFacilityEndpoint: Endpoint {
    
    case getAllFrom(searched: TableName)
    case create(name: TableName, id: Int)
    case delete(name: TableName, id: Int)
    
    case getAllIdFrom(searched: TableName)
    
    enum TableName {
        
        case client(fullName: String? = nil, birthday: String? = nil, age: Int? = nil, address: String? = nil)
        case consultingHours(info: String? = nil)
        case doctor(specializationId: Int? = nil, fullName: String? = nil, age: Int? = nil, employmentLength: Int? = nil)
        case paidService(consultingHoursId: Int? = nil, cost: Int? = nil, info: String? = nil)
        case record(paidServiceId: Int? = nil, doctorId: Int? = nil, clientId: Int? = nil, dateTime: String? = nil)
        case specialization(name: String? = nil)
        case history
        
        var value: String {
            switch self {
            case .client: return "client"
            case .consultingHours: return "consulting_hours"
            case .doctor: return "doctor"
            case .paidService: return "paid_service"
            case .record: return "record"
            case .specialization: return "specialization"
            case .history: return "history"
            }
        }
    }
    
    var scheme: String {
        switch self {
        default:
            return "http"
        }
    }
    
    var baseURL: String {
        switch self {
        default:
            return "localhost"
        }
    }
    
    var path: String {
        switch self {
        case .create:
            return "/course/insert.php"
        case .getAllFrom:
            return "/course/getAll.php"
        case .delete:
            return "/course/delete.php"
        case .getAllIdFrom:
            return "/course/getAllId.php"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getAllFrom(let name):
            return [URLQueryItem(name: "entity", value: name.value)]
        case .create(let name, let id):
            switch name {
            case .specialization(let specName):
                return [URLQueryItem(name: "entity", value: name.value),
                        URLQueryItem(name: "id", value: String(id)),
                        URLQueryItem(name: "name", value: specName)]
                
            case .consultingHours(let info):
                return [URLQueryItem(name: "entity", value: name.value),
                        URLQueryItem(name: "id", value: String(id)),
                        URLQueryItem(name: "info", value: info)]
                
            case .client(let fullName, let birthday, let age, let address):
                return [URLQueryItem(name: "entity", value: name.value),
                        URLQueryItem(name: "id", value: String(id)),
                        URLQueryItem(name: "full_name", value: fullName),
                        URLQueryItem(name: "birthday", value: birthday),
                        URLQueryItem(name: "age", value: String(age ?? 0)),
                        URLQueryItem(name: "address", value: address)]
                
            case .doctor(let specializationId, let fullName, let age, let employmentLength):
                return [URLQueryItem(name: "entity", value: name.value),
                        URLQueryItem(name: "id", value: String(id)),
                        URLQueryItem(name: "specialization_id", value: String(specializationId ?? 0)),
                        URLQueryItem(name: "full_name", value: fullName),
                        URLQueryItem(name: "age", value: String(age ?? 0)),
                        URLQueryItem(name: "employment_length", value: String(employmentLength ?? 0))]
                
            case .paidService(let consultingHoursId, let cost, let info):
                return [URLQueryItem(name: "entity", value: name.value),
                        URLQueryItem(name: "id", value: String(id)),
                        URLQueryItem(name: "consulting_hours_id", value: String(consultingHoursId ?? 0)),
                        URLQueryItem(name: "cost", value: String(cost ?? 0)),
                        URLQueryItem(name: "info", value: info)]
                
            case .record(let paidServiceId, let doctorId, let clientId, let dateTime):
                return [URLQueryItem(name: "entity", value: name.value),
                        URLQueryItem(name: "id", value: String(id)),
                        URLQueryItem(name: "paid_service_id", value: String(paidServiceId ?? 0)),
                        URLQueryItem(name: "doctor_id", value: String(doctorId ?? 0)),
                        URLQueryItem(name: "client_id", value: String(clientId ?? 0)),
                        URLQueryItem(name: "date_time", value: dateTime)]
            default:
                return [URLQueryItem(name: "", value: "")]
            }
        case .delete(let name, let id):
            return [URLQueryItem(name: "entity", value: name.value),
                    URLQueryItem(name: "id", value: "\(id)")]
        case .getAllIdFrom(let name):
            return [URLQueryItem(name: "entity", value: name.value)]
        }
    }
    
    var method: String {
        switch self {
        case .getAllFrom:
            return "GET"
        default:
            return "POST"
        }
    }
    
}
