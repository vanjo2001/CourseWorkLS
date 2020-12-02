//
//  Models.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 14.11.20.
//

import Foundation



struct Client: Decodable, Comparable {
    
    static func < (lhs: Client, rhs: Client) -> Bool {
        return lhs.id < rhs.id
    }
    
    let id: Int
    let fullName: String
    let birthday: String?
    let age: Int
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case id, age, birthday, address
        case fullName = "full_name"
    }
}

struct Specialization: Decodable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

struct Doctor: Decodable {
    let id: Int
    let specializationId: Int
    let fullName: String
    let age: Int
    let lengthOfEmployment: Int

    enum CodingKeys: String, CodingKey {
        case id, age
        case specializationId = "specialization_id"
        case lengthOfEmployment = "employment_length"
        case fullName = "full_name"
    }
}


struct ConsultingHours: Decodable {
    let id: Int
    let info: String

    enum CodingKeys: String, CodingKey {
        case id, info
    }
}

struct PaidService: Decodable {
    let id: Int
    let consultingHoursId: Int
    let cost: Int
    let info: String

    enum CodingKeys: String, CodingKey {
        case id, cost, info
        case consultingHoursId = "consulting_hours_id"
    }
}

struct Record: Decodable {
    let id: Int
    let paidServiceId: Int
    let doctorId: Int
    let clientId: Int
    let dateTime: String

    enum CodingKeys: String, CodingKey {
        case id
        case paidServiceId = "paid_service_id"
        case doctorId = "doctor_id"
        case clientId = "client_id"
        case dateTime = "date_time"
    }
}

struct History: Decodable {
    let id: Int
    let clientName: String
    let paidServiceName: String
    let cost: Int
    let dateTime: String
    
    enum CodingKeys: String, CodingKey {
        case id, cost
        case clientName = "client_name"
        case paidServiceName = "paid_service_name"
        case dateTime = "date_time"
    }
    
}

struct Identificator: Decodable {
    let id: Int
}





