//
//  FakeImageSearchRepository.swift
//  ImageGalleryTests
//
//  Created by Venkat on 18/07/22.
//

import Foundation
import Combine
@testable import ImageGallery

class FakeImageSearchRepository: Repository {
    
    var photoRecords: [PhotoRecord]?
    var serviceError = ServiceError.dataNotFound
    
    func searchPhotos(for keyword: String) -> Future<[PhotoRecord], ServiceError> {
        return Future {[unowned self] promise in
            
            if let photoRecords = self.photoRecords {
                promise(.success(photoRecords))
            }else {
                promise(.failure(self.serviceError))
            }
        }
    }
    
    func enqueueSuccessResponse(photoRecords: [PhotoRecord]) {
        self.photoRecords = photoRecords
    }
    
    func enqueueFailureResponse(serviceError: ServiceError) {
        self.serviceError = serviceError
    }
}
