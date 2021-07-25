//
//  Meteor.swift
//  Fallen Meteors
//
//  Created by Naveen George Thoppan on 18/07/2021.
//

import Foundation

struct Meteor : Codable {
    let name : String?
    let id : String?
    let nametype : String?
    let recclass : String?
    let mass : Double?
    let fall : String?
    let year : Date?
    let reclat : String?
    let reclong : String?
    let geolocation : Geolocation?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case id = "id"
        case nametype = "nametype"
        case recclass = "recclass"
        case mass = "mass"
        case fall = "fall"
        case year = "year"
        case reclat = "reclat"
        case reclong = "reclong"
        case geolocation = "geolocation"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        nametype = try values.decodeIfPresent(String.self, forKey: .nametype)
        recclass = try values.decodeIfPresent(String.self, forKey: .recclass)
        mass = Double(try (values.decodeIfPresent(String.self, forKey: .mass) ?? "0")) ?? 0
        fall = try values.decodeIfPresent(String.self, forKey: .fall)
        let yearString = try values.decodeIfPresent(String.self, forKey: .year) ?? ""
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let yearFromString = RFC3339DateFormatter.date(from: yearString) {
            year = yearFromString
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.year], debugDescription: "Date string does not match format expected by formatter."))
                        
        }
        reclat = try values.decodeIfPresent(String.self, forKey: .reclat)
        reclong = try values.decodeIfPresent(String.self, forKey: .reclong)
        geolocation = try values.decodeIfPresent(Geolocation.self, forKey: .geolocation)
    }

}

struct Geolocation : Codable {
    let latitude : Double?
    let longitude : Double?

    enum CodingKeys: String, CodingKey {

        case latitude = "latitude"
        case longitude = "longitude"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = Double (try (values.decodeIfPresent(String.self, forKey: .latitude) ?? "0.0")) ?? 0.0
        longitude = Double (try values.decodeIfPresent(String.self, forKey: .longitude) ?? "0.0") ?? 0.0
    }

}
