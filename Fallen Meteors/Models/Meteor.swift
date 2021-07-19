//
//  Meteor.swift
//  Fallen Meteors
//
//  Created by Naveen George Thoppan on 18/07/2021.
//

import Foundation

import Foundation

import Foundation

struct Meteor : Codable {
    let name : String?
    let id : String?
    let nametype : String?
    let recclass : String?
    let mass : String?
    let fall : String?
    let year : String?
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
        mass = try values.decodeIfPresent(String.self, forKey: .mass)
        fall = try values.decodeIfPresent(String.self, forKey: .fall)
        year = try values.decodeIfPresent(String.self, forKey: .year)
        reclat = try values.decodeIfPresent(String.self, forKey: .reclat)
        reclong = try values.decodeIfPresent(String.self, forKey: .reclong)
        geolocation = try values.decodeIfPresent(Geolocation.self, forKey: .geolocation)
    }

}

struct Geolocation : Codable {
    let latitude : String?
    let longitude : String?

    enum CodingKeys: String, CodingKey {

        case latitude = "latitude"
        case longitude = "longitude"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
    }

}
