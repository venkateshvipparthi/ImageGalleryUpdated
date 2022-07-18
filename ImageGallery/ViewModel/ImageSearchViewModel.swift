//
//  ImageSearchViewModel.swift
//  ImageGallery
//
//  Created by Venkat on 28/04/2022.
//

import Foundation
import Combine
import UIKit

protocol ImageSearchViewModelInput {
    func search(for keyword: String)
    func getImage(for index:Int, completion:@escaping (Data)-> Void)
}

protocol ImageSearchViewModelOutput {
    var stateBinding: Published<ViewState>.Publisher { get }
    var photoDetailsCount:Int { get }
    var photoRecords:[PhotoRecord] { get }
}

final class ImageSearchViewModel {
    
    private let photoSearchRepository: Repository
    private let imageRepository: ImageDownloader

    private var cancellables:Set<AnyCancellable> = Set()
    
    @Published  var state: ViewState = .none
    
    var photoRecords:[PhotoRecord] = []
    
    init(photoSearchRepository: Repository,  imageRepository: ImageDownloader) {
        self.photoSearchRepository = photoSearchRepository
        self.imageRepository  = imageRepository
    }
    
    deinit {
        cancellables.forEach { $0.cancel()}
    }
}

extension ImageSearchViewModel: ImageSearchViewModelInput {
    func search(for keyword: String){
        state = ViewState.loading
        let publisher = photoSearchRepository.searchPhotos(for: keyword)
        
        let cancalable = publisher.sink { [weak self ]completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self?.photoRecords = []
                self?.state = ViewState.error(NSLocalizedString("networkError", comment: ""))
            }
        } receiveValue: { [weak self] photoRecords in
            self?.photoRecords = photoRecords
            self?.state = ViewState.finishedLoading
        }
        self.cancellables.insert(cancalable)
    }
    
    func getImage(for index:Int, completion:@escaping (Data)-> Void) {
        let publisher = imageRepository.getImages(for: self.photoRecords[index].url)
    
        let cancalable = publisher.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                break
              // Log not able to download Image.
            }
        } receiveValue: { imageData in
            completion(imageData)
        }
        self.cancellables.insert(cancalable)
    }
}

extension ImageSearchViewModel: ImageSearchViewModelOutput {
    
    var stateBinding: Published<ViewState>.Publisher{ $state }

    var photoDetailsCount: Int {
        return photoRecords.count
    }
}
