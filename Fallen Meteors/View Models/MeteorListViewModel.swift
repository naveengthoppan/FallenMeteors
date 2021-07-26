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
    
    typealias DidFetchMeteorDataCompletion = ([MeteorViewModel]?, MeteorDataError?) -> Void
    
    // MARK: - Properties

    var didFetchMeteorData: DidFetchMeteorDataCompletion?
    var meteorList: [MeteorViewModel]?
    var sortedMeteorList = [MeteorViewModel]()
    var favouriteMeteors = [MeteorViewModel]()
    // MARK: - Initialization
    init() {
        fetchMeteorData()
    }
    
    // MARK: - Helper Methods
    private func fetchMeteorData() {
      
        let meteorRequest = MeteorRequest(baseUrl: MeteorService.baseUrl)
        URLSession.shared.dataTask(with: meteorRequest.url) { [weak self] (data, response, error) in
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
                        self?.meteorList = MeteorResults(meteors: meteorResposne).results
                    self?.didFetchMeteorData?(MeteorResults(meteors: meteorResposne).results, nil)
                    
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
    
    func fetchFavouriteMeteors() {
        // Create Fetch Request
        favouriteMeteors = CoreDataManager(modelName: "MeteorData").fetchFavouriteMeteors()
        self.didFetchMeteorData?(favouriteMeteors, nil)
    }
    
    func removeFavouriteMeteors(indexPath: IndexPath) {
        // Create Fetch Request
       CoreDataManager(modelName: "MeteorData").removeMeteorFromFavourites(meteor: favouriteMeteors[indexPath.row])
                                                                                            
    }
    
    func sortByDate(isFavourite: Bool) {
        if isFavourite {
            favouriteMeteors = favouriteMeteors.sorted(by: {$0.year!.compare($1.year!) == .orderedAscending})
            self.didFetchMeteorData?(favouriteMeteors, nil)
        } else {
            meteorList = meteorList!.sorted(by: {$0.year!.compare($1.year!) == .orderedAscending})
            self.didFetchMeteorData?(meteorList, nil)
        }
    }
    
    func sortBySize(isFavourite: Bool) {
        if isFavourite {
            favouriteMeteors = favouriteMeteors.sorted(by: {$0.mass ?? 0 < $1.mass ?? 0})
            self.didFetchMeteorData?(favouriteMeteors, nil)
        } else {
            meteorList = meteorList!.sorted(by: {$0.mass ?? 0 < $1.mass ?? 0})
            self.didFetchMeteorData?(meteorList, nil)
        }
    }
    
    func sortByName(isFavourite: Bool) {
        if isFavourite {
            favouriteMeteors = favouriteMeteors.sorted(by: { $0.name! < $1.name!})
            self.didFetchMeteorData?(favouriteMeteors, nil)
        } else {
            meteorList = meteorList!.sorted(by: { $0.name! < $1.name!})
            self.didFetchMeteorData?(meteorList, nil)
        }
        
    }
    
    func reverseList(isFavourite: Bool) {
        if isFavourite {
            favouriteMeteors = favouriteMeteors.reversed()
            self.didFetchMeteorData?(favouriteMeteors, nil)
        } else {
            meteorList = meteorList!.reversed()
            self.didFetchMeteorData?(meteorList, nil)
        }
    }
    
    func refreshData() {
        fetchMeteorData()
    }
    
    func detailViewModel(indexPath: IndexPath, isFavourite: Bool) -> MeteorDetailViewModel {
        if isFavourite {
            return MeteorDetailViewModel(meteor: (favouriteMeteors[indexPath.row]))
        }
        return MeteorDetailViewModel(meteor: (meteorList?[indexPath.row])!)
    }
}
