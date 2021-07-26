//
//  MeteorDetailViewModel.swift
//  Fallen Meteors
//
//  Created by Naveen George Thoppan on 24/07/2021.
//

import Foundation
import CoreData

class MeteorDetailViewModel {
    var meteor: MeteorViewModel?
    
    init(meteor: MeteorViewModel) {
        self.meteor = meteor
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
            NSPersistentContainer(name: "MeteorData")
        }()
    var managedObjectContext: NSManagedObjectContext?
    
    func saveToCoreData() {
        CoreDataManager(modelName: "MeteorData").addMeteorToFavourites(meteor: meteor!)
    }
    
    func checkFavouriteStatus() -> Bool {
        return CoreDataManager(modelName: "MeteorData").checkIfAlreadyFavourited(meteor: meteor!)
    }

    func removeFavouriteMeteors() {
        // Create Fetch Request
        CoreDataManager(modelName: "MeteorData").removeMeteorFromFavourites(meteor: meteor!)
                                                                                            
    }

}
