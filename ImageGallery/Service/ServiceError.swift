//
//  ServiceError.swift
//  ImageGallery
//
//  Created by Venkat on 18/07/22.
//

import Foundation

enum ServiceError: Error {
    case failedToCreateRequest
    case dataNotFound
    case parsingError
}
