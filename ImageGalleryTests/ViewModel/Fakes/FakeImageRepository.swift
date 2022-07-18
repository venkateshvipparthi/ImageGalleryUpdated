//
//  FakeImageRepository.swift
//  ImageGalleryTests
//
//  Created by Venkat on 18/07/22.
//

import Foundation
import Combine
@testable import ImageGallery


class FakeImageRepository: ImageDownloader {
    
    var imageData: Data?
    var serviceError = ServiceError.dataNotFound
    
    func getImages(for url: String) -> Future<Data, ServiceError> {
        return Future {[unowned self] promise in
            if let imageData = self.imageData {
                promise(.success(imageData))
            }else {
                promise(.failure(self.serviceError))
            }
        }
    }
    
    func enqueueSuccessResponse(imageData: Data) {
        self.imageData = imageData
    }
    
    func enqueueFailureResponse(serviceError: ServiceError) {
        self.serviceError = serviceError
    }
}
