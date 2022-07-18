//
//  ImageRepository.swift
//  ImageGallery
//
//  Created by Venkat on 17/07/22.
//

import Foundation
import Combine

protocol ImageDownloader {
   func getImages(for url: String)-> Future<Data, ServiceError>
}

protocol ImageCacher {
    func getImage(url:String)-> Data?
    func saveImage(url:String, data:Data)
}


final class ImageRepository {
    
    private let networkManager:Networkble
    private var cancellables:Set<AnyCancellable> = Set()
    private var cache = NSCache<NSString, NSData>()

    init(networkManager:Networkble) {
        self.networkManager = networkManager
        cache.countLimit = 100
    }
    
    deinit {
        cancellables.forEach { $0.cancel()}
    }
}

extension ImageRepository: ImageDownloader {
    func getImages(for url: String)-> Future<Data, ServiceError> {

        return Future { [weak self] promise in
            
            if let data = self?.getImage(url: url) {
                return promise(.success(data))
            }
            let request = Request(baseUrl: url, path:"", params:[:])
            
            let publisher = self?.networkManager.get(apiRequest: request)
            
            let cancalable = publisher?.sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    promise(.failure(ServiceError.dataNotFound))
                }
            } receiveValue: { data in
                
                self?.saveImage(url: url, data: data)
                return promise(.success(data))
            }
            
            self?.cancellables.insert(cancalable!)
        }
    }
}

extension ImageRepository: ImageCacher {
    func getImage(url: String) -> Data? {
        return cache.object(forKey: url as NSString) as Data?
    }
    
    func saveImage(url: String, data: Data) {
        cache.setObject(data as NSData, forKey: url as NSString)
    }
}
