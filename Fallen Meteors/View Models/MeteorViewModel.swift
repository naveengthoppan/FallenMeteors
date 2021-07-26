//
//  MeteorViewModel.swift
//  Fallen Meteors
//
//  Created by Naveen George Thoppan on 25/07/2021.
//

import Foundation

class MeteorViewModel: Equatable {
    static func == (lhs: MeteorViewModel, rhs: MeteorViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    var id: String?
    var name: String?
    var recclass: String?
    var mass: Double?
    var year: Date?
    var latitude: Double?
    var longitude: Double?
    
    init(meteor: Meteor) {
        self.id = meteor.id
        self.name = meteor.name
        self.recclass = meteor.recclass
        self.mass = meteor.mass
        self.year = meteor.year
        self.latitude = meteor.geolocation?.latitude
        self.longitude = meteor.geolocation?.longitude
    }
    
    init(meteor: MeteorData) {
        self.id = meteor.id
        self.name = meteor.name
        self.recclass = meteor.recclass
        self.mass = meteor.mass
        self.year = meteor.year
        self.latitude = meteor.latitude
        self.longitude = meteor.longitude
    }
}

class MeteorResults {
    var results = [MeteorViewModel]()
    
    init(meteors: [Meteor]) {
        results = [MeteorViewModel]()
        for meteor in meteors {
            results.append(MeteorViewModel(meteor: meteor))
        }
    }
    
    init(meteors: [MeteorData]) {
        results = [MeteorViewModel]()
        for meteor in meteors {
            results.append(MeteorViewModel(meteor: meteor))
        }
    }
}
