//
//  ImageGalleryTests.swift
//  ImageGalleryTests
//
//  Created by Venkat on 28/04/2022.
//

import XCTest
@testable import ImageGallery

class ImageSearchViewModelTests: XCTestCase {
    
    var viewModel:ImageSearchViewModel!
    var fakeSearchRepository = FakeImageSearchRepository()

    var fakeImageRepository = FakeImageRepository()

    override func setUpWithError() throws {
        viewModel = ImageSearchViewModel(photoSearchRepository: fakeSearchRepository, imageRepository: fakeImageRepository)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    
    // SuccessFull Search
    func testWhenImagesSearchIsSuccessfull() {
        // GIVEN
        
        fakeSearchRepository.enqueueSuccessResponse(photoRecords: [PhotoRecord(name:"test1", url:"www.test1@test.com"),PhotoRecord(name:"test2", url: "www.test1@test.com")])

        // WHEN
        
        viewModel.search(for:"valid")

        // THEN
        
        XCTAssertEqual(viewModel.photoDetailsCount, 2)

        XCTAssertEqual(viewModel.photoRecords.first?.name, "test1")

    }
    
    // Failed Search
    func testWhenImageSearchFailed() {
        // GIVEN
        
        fakeSearchRepository.enqueueFailureResponse(serviceError: ServiceError.dataNotFound)
        // WHEN
        viewModel.search(for:"invalid")

        // THEN

        XCTAssertEqual(viewModel.photoDetailsCount, 0)
    }

    
    // Image Data Download success
    func testWhenImagesDataDownloadSuccessFull() {
        
        // GIVEN
        
        fakeSearchRepository.enqueueSuccessResponse(photoRecords: [PhotoRecord(name:"test1", url:"www.test1@test.com"),PhotoRecord(name:"test2", url: "www.test1@test.com")])

        // WHEN
        
        viewModel.search(for:"valid")
        
        fakeImageRepository.enqueueSuccessResponse(imageData: Data())

        // WHEN
        
        viewModel.getImage(for: 0) { data in
            XCTAssertNotNil(data)
        }
    }
    
    
    // Image Data Download failure
    func testWhenImagesDataDownloadFailed() {
        
        // GIVEN
        
        fakeSearchRepository.enqueueSuccessResponse(photoRecords: [PhotoRecord(name:"test1", url:"www.test1@test.com"),PhotoRecord(name:"test2", url: "www.test1@test.com")])

        // WHEN
        
        viewModel.search(for:"valid")
        
        fakeImageRepository.enqueueFailureResponse(serviceError: ServiceError.dataNotFound)

        // WHEN
        
        viewModel.getImage(for: 0) { data in
            XCTAssertNil(data)
        }
    }
}
