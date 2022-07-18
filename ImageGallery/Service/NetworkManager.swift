//
//  NetworkManager.swift
//  ImageGallery
//
//  Created by Venkat on 28/04/2022.
//

import Foundation
import Combine

protocol Networkble {
    func get(apiRequest:Requestable)-> Future<Data, ServiceError>
}

final class NetworkManager: Networkble {
    let session:URLSession
    init(session:URLSession = URLSession.shared) {
        self.session = session
    }
    
    func get(apiRequest: Requestable) -> Future<Data, ServiceError> {
        return Future { [weak self] promise in
            guard let request = URLRequest.getURLRequest(for: apiRequest) else {
                promise(.failure(ServiceError.failedToCreateRequest))
                return
            }
            self?.session.dataTask(with: request, completionHandler: { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    return promise(.failure(ServiceError.dataNotFound))
                }
                guard let _data = data, error == nil else {
                    return promise(.failure(ServiceError.dataNotFound))
                }
                return promise(.success(_data))
            }).resume()
        }
    }
}

