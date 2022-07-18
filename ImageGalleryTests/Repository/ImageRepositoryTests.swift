//
//  ImageRepository.swift
//  ImageGalleryTests
//
//  Created by Venkat on 18/07/22.
//

import XCTest
import Combine
@testable import ImageGallery

class ImageRepositoryTests: XCTestCase {

    var imageRepository: ImageRepository!
    let mockNetworkManager  = MockNetworkManager()

    override func setUpWithError() throws {
        
        imageRepository = ImageRepository(networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
        imageRepository = nil
    }

    // Image download success
    func testValidImageDownloaded() {
        let publisher = imageRepository.getImages(for: "validUrl")
        
        let _ =  publisher.sink { completion in
            
        } receiveValue: { data in
            XCTAssertNotNil(data)
        }

    }
    
    // Test reading from Cached Image
    func testCachedImageData() {
        
        // GIVEN
        let _ = imageRepository.getImages(for: "validUrl")
        
        // WHEN
        
       let data =  imageRepository.getImage(url:"validUrl")
        
        
        // THEN

        XCTAssertNotNil(data)

        // 2nd time onwards calling getImages for same URL should return data from cache
        
        
        let publisher = imageRepository.getImages(for: "validUrl")
        
        let _ =  publisher.sink { completion in
            
        } receiveValue: { data in
            XCTAssertNotNil(data)
        }

    }
    
    //  Image download failure
    func testDataNotFoundResponseImageDownload() {
        
        mockNetworkManager.enqueuResponse(responseJson:"invalidURL")
        let publisher = imageRepository.getImages(for: "validUrl")
        
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
