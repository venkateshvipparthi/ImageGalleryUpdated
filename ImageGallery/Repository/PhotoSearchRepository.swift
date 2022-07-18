//
//  PhotoServiceRepository.swift
//  ImageGallery
//
//  Created by Venkat on 17/07/22.
//

import Foundation
import Combine

protocol Repository {
    func searchPhotos(for keyword: String)-> Future<[PhotoRecord], ServiceError>
}

final class PhotoSearchRepository: Repository {
    
    private let networkManager:Networkble
    private var cancellables:Set<AnyCancellable> = Set()
    
    init(networkManager:Networkble) {
        self.networkManager = networkManager
    }
    
    func searchPhotos(for keyword: String)-> Future<[PhotoRecord], ServiceError> {
        
        return Future { [weak self] promise in
            let request = Request(baseUrl: APIURLs.baseUrl, path:"", params: ["method":APIURLs.photoMethod, "text": "\(keyword)", "api_key": APIURLs.apiKey, "format" : "json", "nojsoncallback" : "1"])
            
            let publisher = self?.networkManager.get(apiRequest: request)
            
            let cancalable = publisher?.sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    promise(.failure(ServiceError.dataNotFound))
                }
            } receiveValue: {  data in
                guard let decodedResponse = try? JSONDecoder().decode(ImageResponseDTO.self, from: data) else {
                    return promise(.failure(ServiceError.parsingError))
                }
                
                let phototsDetails = decodedResponse.toDomain()
                
                return promise(.success(phototsDetails))
            }
            
            self?.cancellables.insert(cancalable!)
        }
    }
}
