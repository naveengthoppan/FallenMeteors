//
//  MeteorRequest.swift
//  Fallen Meteors
//
//  Created by Naveen George Thoppan on 18/07/2021.
//

import Foundation

struct MeteorRequest {
    
    // MARK: - Properties

        let baseUrl: URL
    
    var url: URL {
        var urlComponenets = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
         urlComponenets?.queryItems = [
            URLQueryItem(name: "$$app_token", value: MeteorService.appToken),
            URLQueryItem(name: "$where", value: MeteorService.yearCondition),
         ]
         guard let finalUrl = urlComponenets?.url else {
                 return baseUrl
         }
        return finalUrl
    }
    
}
