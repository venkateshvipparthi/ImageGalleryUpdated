//
//  MockUrlSession.swift
//  ImageGalleryTests
//
//  Created by Venkat on 18/07/22.
//

import Foundation
@testable import ImageGallery

class MockURLSession: URLSession {
    let mockDataTask =  MockURLSessionDataTask()
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        mockDataTask.completionHandler = completionHandler
        return mockDataTask
    }
    
    func enqueueResponse(urlResponse: HTTPURLResponse, error: ServiceError?) {
        mockDataTask.urlResponse = urlResponse
        mockDataTask.serviceError = error
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    var  urlResponse: HTTPURLResponse!
    var  serviceError: ServiceError!
    override func resume() {
        completionHandler!("success".data(using:.utf8), urlResponse, serviceError)
    }
}
