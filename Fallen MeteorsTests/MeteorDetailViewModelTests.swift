//
//  MeteorDetailViewModelTests.swift
//  Fallen MeteorsTests
//
//  Created by Naveen George Thoppan on 26/07/2021.
//

import XCTest
@testable import Fallen_Meteors

var coreDataManager: CoreDataManager!
var viewModel: MeteorDetailViewModel!

class MeteorDetailViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let data = loadStub(name: "response", extension: "json")
        let decoder = JSONDecoder()
        let meteorResponse = try! decoder.decode([Meteor].self, from: data)

    viewModel = MeteorDetailViewModel(meteor: MeteorResults(meteors: meteorResponse).results.first!)
     
     coreDataManager = CoreDataManager(modelName: "MeteorData")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddMeteorFavourite() {
        coreDataManager.managedObjectContext.perform {
            XCTAssertNotNil(viewModel.meteor)
            let meteorSaveResult = coreDataManager.addMeteorToFavourites(meteor: viewModel.meteor!)
                XCTAssertNotNil(meteorSaveResult)
            XCTAssertEqual(viewModel.meteor, coreDataManager.fetchFavouriteMeteors().first)
      }
    }
    
    func testRemoveMeteorFavourite() {
        coreDataManager.managedObjectContext.perform {
            XCTAssertNotNil(viewModel.meteor)
            let meteorSaveResult = coreDataManager.removeMeteorFromFavourites(meteor: viewModel.meteor!)
            XCTAssertNotNil(meteorSaveResult)
            XCTAssert(coreDataManager.fetchFavouriteMeteors().count == 0)
      }
    }

}
