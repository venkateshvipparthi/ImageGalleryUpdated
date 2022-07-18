//
//  MainCoordinator.swift
//  ImageGallery
//
//  Created by Venkat on 29/04/2022.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

final class MainCoordinator: Coordinator {
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let imageSearchViewController = ImageSearchViewController.storyboardViewController()
        
        let networkManager = NetworkManager()
        let repository = PhotoSearchRepository(networkManager: networkManager)
        
        let imageRepository = ImageRepository(networkManager: networkManager)
        imageSearchViewController.coordinator = self
        imageSearchViewController.viewModel = ImageSearchViewModel(photoSearchRepository: repository, imageRepository: imageRepository)
        navigationController.pushViewController(imageSearchViewController, animated: true)
    }
    
}
