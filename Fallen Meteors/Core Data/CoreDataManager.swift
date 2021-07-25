//
//  CoreDataManager.swift
//  Fallen Meteors
//
//  Created by Naveen George Thoppan on 25/07/2021.
//

import CoreData

final class CoreDataManager {
    // MARK: - Properties
    
    private let modelName: String
    
    // MARK: - Initialization
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - Core Data Stack

    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

        return managedObjectContext
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }

        return managedObjectModel
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }

        return persistentStoreCoordinator
    }()
    
    func addMeteorToFavourites(meteor: MeteorViewModel) {
        let fetchRequest = NSFetchRequest<MeteorData>(entityName: "MeteorData")

        // Add Predicate
        let predicate = NSPredicate(format: "name == %@ AND id == %@", meteor.name!, meteor.id!)
        fetchRequest.predicate = predicate

        do {
            let records = try managedObjectContext.fetch(fetchRequest) as [NSManagedObject]

            if records.count == 0 {
                let meteorData = MeteorData(context: managedObjectContext)
                meteorData.id = meteor.id
                meteorData.name = meteor.name
                meteorData.recclass = meteor.recclass
                meteorData.mass = meteor.mass ?? 0.0
                meteorData.year = meteor.year
                meteorData.latitude = meteor.latitude ?? 0.0
                meteorData.longitude = meteor.longitude ?? 0.0
                
                do {
                    // Save Book to Persistent Store
                    try managedObjectContext.save()
                    
                } catch {
                    print("Unable to Meteor Data, \(error)")
                }
            }

        } catch {
            print(error)
        }
    }
    
    func fetchFavouriteMeteors() -> [MeteorViewModel] {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<MeteorData> = MeteorData.fetchRequest()
        var meteorResults = [MeteorViewModel]()
        // Perform Fetch Request
        managedObjectContext.performAndWait {
            do {
                // Execute Fetch Request
                let result = try fetchRequest.execute()

                // Update Books Label
                print(result)
                meteorResults = MeteorResults(meteors: result).results

            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
        return meteorResults
    }
    
    func  removeMeteorFromFavourites(meteor: MeteorViewModel) {
        let fetchRequest = NSFetchRequest<MeteorData>(entityName: "MeteorData")

        // Add Predicate
        let predicate = NSPredicate(format: "name == %@ AND id == %@", meteor.name!, meteor.id as! CVarArg)
        fetchRequest.predicate = predicate

        do {
            let records = try managedObjectContext.fetch(fetchRequest) as [NSManagedObject]

            for record in records {
                managedObjectContext.delete(record)
                do {
                    try managedObjectContext.save()
                }
                catch {
                    print(error)
                }
            }

        } catch {
            print(error)
        }
    }
    
    func checkIfAlreadyFavourited(meteor: MeteorViewModel) -> Bool {
        let fetchRequest = NSFetchRequest<MeteorData>(entityName: "MeteorData")

        // Add Predicate
        let predicate = NSPredicate(format: "name == %@ AND id == %@", meteor.name!, meteor.id!)
        fetchRequest.predicate = predicate

        do {
            let records = try managedObjectContext.fetch(fetchRequest) as [NSManagedObject]

            return records.count > 0
            
        } catch {
            print(error)
        }
        return false
    }
}
