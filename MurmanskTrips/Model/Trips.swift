//
//  Trips.swift
//  MurmanskTrips
//
//  Created by Maxim Kuznetsov on 21.11.2020.
//

import Foundation

struct Trips: Codable {
    let data: [Trip]
}

struct Trip: Codable {
    let title: String
    let city: City
    let rating: Int
    let duration: String
    let images: [String]
}

struct City: Codable {
    let title: String
}
