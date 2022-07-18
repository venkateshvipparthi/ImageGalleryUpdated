//
//  NetworkManagerTests.swift
//  ImageGalleryTests
//
//  Created by Venkat on 18/07/22.
//

import XCTest
import Combine
@testable import ImageGallery

class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager!
    var mockURLSession: MockURLSession!
    
    override func setUpWithError() throws {
        mockURLSession = MockURLSession()
        networkManager = NetworkManager(session: mockURLSession)
    }

    override func tearDownWithError() throws {
        networkManager = nil
    }
    
    // Invalid Empty request URL
    func testFailedToCreateRequestForEmptyURL() {
        
        // GIVEN
        
        let request = Request(baseUrl:"", path:"", params: [:])
        // WHEN
        
        let publisher = networkManager.get(apiRequest: request)
        
       let _ =  publisher.sink { completion in
           switch completion {
           case .finished:
               break
           case .failure(let error):
               XCTAssertEqual(error, ServiceError.failedToCreateRequest)
           }
       } receiveValue: { _ in
        }
    }
    
    // Valid Response Code - 200
    func testWhenResponseCodeIsValid() {
        
        // GIVEN
        
        let request = Request(baseUrl:"test", path:"", params: ["q":"test"])
        mockURLSession.enqueueResponse(urlResponse: HTTPURLResponse(url:URL(string: "test")!, statusCode: 200, httpVersion: nil, headerFields: nil)!, error: nil)
        // WHEN
        
        let publisher = networkManager.get(apiRequest: request)
        
       let _ =  publisher.sink { completion in
           switch completion {
           case .finished:
               break
           case .failure(_): break
              
           }
       } receiveValue: { data in
           XCTAssertNotNil(data)
        }
    }
    
    // Invalid Response Code (not in 200 to 299 range)
    func testWhenResponseCodeIsNotSuccess() {
        
        // GIVEN
        
        let request = Request(baseUrl:"test", path:"", params: [:])
        mockURLSession.enqueueResponse(urlResponse: HTTPURLResponse(url:URL(string: "test")!, statusCode: 404, httpVersion: nil, headerFields: nil)!, error: ServiceError.dataNotFound)
        // WHEN
        
        let publisher = networkManager.get(apiRequest: request)
        
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
    
    
    // Valid Response Code but Error
    func testWhenResponseCodeIsValidButError() {
        
        // GIVEN
        
        let request = Request(baseUrl:"test", path:"", params: [:])
        mockURLSession.enqueueResponse(urlResponse: HTTPURLResponse(url:URL(string: "test")!, statusCode: 200, httpVersion: nil, headerFields: nil)!, error: ServiceError.dataNotFound)
        // WHEN
        
        let publisher = networkManager.get(apiRequest: request)
        
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


