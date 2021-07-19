//
//  MeteorListViewModel.swift
//  Fallen Meteors
//
//  Created by Naveen George Thoppan on 18/07/2021.
//

import Foundation

class MeteorListViewModel {
    enum MeteorDataError: Error {
            case noMeteorDataAvailable
    }
    
    
    typealias DidFetchMeteorDataCompletion = ([Meteor]?, MeteorDataError?) -> Void
    
    // MARK: - Properties

    var didFetchMeteorData: DidFetchMeteorDataCompletion?
    var meteorList = [Meteor]()
    
    // MARK: - Initialization
    init() {
        fetchMeteorData()
    }
    
    // MARK: - Helper Methods
    private func fetchMeteorData() {
      
        let meteorRequest = MeteorRequest(baseUrl: MeteorService.baseUrl)
        URLSession.shared.dataTask(with: meteorRequest.url) { [weak self] (data, response, error) in
            //                if let data = data {
            //                    print("--------GET REQUEST RESPONSE START--------")
            //                    print("CODE: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            //                    print("Response Data:")
            //                    print(String(data: data, encoding: .utf8) ?? "")
            //                    print("--------GET REQUEST RESPONSE END--------")
            //                }
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
            }
            
            if error != nil {
                self?.didFetchMeteorData?(nil, .noMeteorDataAvailable)
            } else if let data = data {
                // Initialize JSON Decoder
                let decoder = JSONDecoder()
                
                do {
                    // Decode JSON Response
                    let meteorResposne = try decoder.decode([Meteor].self, from: data)
                    
                    // Invoke Completion Handler
                    self?.didFetchMeteorData?(meteorResposne, nil)
                    self?.meteorList = meteorResposne
                } catch {
                    print("Unable to Decode JSON Response \(error)")
                    
                    // Invoke Completion Handler
                    self?.didFetchMeteorData?(nil, .noMeteorDataAvailable)
                }
            } else {
                self?.didFetchMeteorData?(nil, .noMeteorDataAvailable)
            }
        }.resume()
        
    }
    
}
