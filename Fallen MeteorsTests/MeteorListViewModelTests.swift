//
//  MeteorListViewModelTests.swift
//  Fallen MeteorsTests
//
//  Created by Naveen George Thoppan on 26/07/2021.
//

import XCTest
@testable import Fallen_Meteors

class MeteorListViewModelTests: XCTestCase {

    var viewModel: MeteorListViewModel!
    var coreDataManager: CoreDataManager!
    
    override func setUpWithError() throws {
           let data = loadStub(name: "response", extension: "json")
           let decoder = JSONDecoder()
           let meteorResponse = try! decoder.decode([Meteor].self, from: data)

           viewModel = MeteorListViewModel()
            viewModel.meteorList = MeteorResults(meteors: meteorResponse).results
        
        coreDataManager = CoreDataManager(modelName: "MeteorData")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReversing() throws {
        let reversedResponse: [MeteorViewModel] = viewModel.meteorList!.reversed()
        viewModel.reverseList()
        XCTAssertEqual(reversedResponse, viewModel.meteorList!)
        
    }
    
    func testMeteorList() throws {
        let data = loadStub(name: "response", extension: "json")
        let decoder = JSONDecoder()
        let meteorResponse = try! decoder.decode([Meteor].self, from: data)
        XCTAssertEqual(viewModel.meteorList?.count, meteorResponse.count)
    }
    
    func testAddToFavourite() throws {
        if let meteor = viewModel.meteorList?.first {
            
            XCTAssertNotNil(meteor, "Meteor should not be nil")
              XCTAssertTrue(meteor.name == "Aarhus")
              XCTAssertTrue(meteor.id == "2")
              XCTAssertNotNil(meteor.id, "id should not be nil")
              XCTAssertNotNil(meteor.name, "name should not be nil")
        }
    }
}
