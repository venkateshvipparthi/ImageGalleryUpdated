//
//  MockNetworkManager.swift
//  ImageGalleryTests
//
//  Created by Venkat on 28/04/2022.
//

import Foundation
@testable import ImageGallery
import Combine

class MockNetworkManager: Networkble {
    private var responseJson: String = "APISuccessResponce"
    func get(apiRequest: Requestable) -> Future<Data, ServiceError> {

        return Future { promise in
            let bundle = Bundle(for:MockNetworkManager.self)
            
            guard let url = bundle.url(forResource:self.responseJson, withExtension:"json"),
                  let data = try? Data(contentsOf: url)

            else {
                promise(.failure(ServiceError.dataNotFound))
                return
            }
        return promise(.success(data))
        }
    }

    func enqueuResponse(responseJson: String) {
        self.responseJson = responseJson
    }
}
