//
//  ImageSearchRepositoryTests.swift
//  ImageGalleryTests
//
//  Created by Venkat on 18/07/22.
//

import XCTest
import Combine
@testable import ImageGallery

class PhotoSearchRepositoryTests: XCTestCase {

    var searchRepository: PhotoSearchRepository!
    let mockNetworkManager  = MockNetworkManager()

    override func setUpWithError() throws {
        
       searchRepository = PhotoSearchRepository(networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
       searchRepository = nil
    }

    // Valid Search Response
    func testSuccessResponsePhotoSearch() {
        let publisher = searchRepository.searchPhotos(for:"cat")
        
       let _ =  publisher.sink { completion in
            
        } receiveValue: { photoRecords in
            XCTAssertEqual(photoRecords.count, 100)
        }

    }
    
    // Parsing Failed due to invalid response
    func testInvalidResponsePhotoSearch() {
        
        mockNetworkManager.enqueuResponse(responseJson:"InvalidSearchResponse")
        let publisher = searchRepository.searchPhotos(for:"cat")
        
       let _ =  publisher.sink { completion in
           switch completion {
           case .finished:
               break
           case .failure(let error):
               XCTAssertEqual(error, ServiceError.parsingError)
           }
        } receiveValue: { _ in
        
        }
    }
    
    // Invalid Repsonse, Data not found - 404
    func testDataNotFoundPhotoSearch() {
        
        mockNetworkManager.enqueuResponse(responseJson:"dataNotFound")
        let publisher = searchRepository.searchPhotos(for:"cat")
        
       let _ =  publisher.sink { completion in
           switch completion {
           case .finished:
               break
           case .failure(let error):
               XCTAssertEqual(error, ServiceError.dataNotFound)
           }
        } receiveValue: { _ in
        
        }
    }
}
