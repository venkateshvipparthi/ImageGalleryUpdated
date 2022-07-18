//
//  ImageSearchViewController.swift
//  ImageGallery
//
//  Created by Venkat on 28/04/2022.
//

import UIKit
import Combine

final class ImageSearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var bindings = Set<AnyCancellable?>()
    
    weak var coordinator: MainCoordinator?
        
    var viewModel: ImageSearchViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModelState()
    }
    
    private func setupUI() {
        self.navigationItem.title = NSLocalizedString("search", comment:"")
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text{
            self.viewModel?.search(for: text)
        }
    }
    
    private func bindViewModelState() {
        let cancellable =  viewModel?.stateBinding.sink { completion in
            
        } receiveValue: { [weak self] launchState in
            DispatchQueue.main.async {
                self?.updateUI(state: launchState)
            }
        }
        self.bindings.insert(cancellable)
    }
    
    private func updateUI(state:ViewState) {
        switch state {
        case .none:
            collectionView.isHidden = true
        case .loading:
            collectionView.isHidden = true
        case .finishedLoading:
            collectionView.isHidden = false
            collectionView.reloadData()
            searchBar.resignFirstResponder()
        case .error(_):
            collectionView.reloadData()
            searchBar.resignFirstResponder()
        }
    }
}

extension ImageSearchViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photoDetailsCount ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImageDetailCollectionViewCell else {return UICollectionViewCell()}
    

        collectionCell.imgDesc.text = viewModel?.photoRecords[indexPath.row].name
        viewModel?.getImage(for: indexPath.row, completion: { imageData in
            DispatchQueue.main.async {
                collectionCell.imageCollectionCell.image = UIImage(data: imageData)
            }
        })
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ImageSearchViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 1 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:300)
    }
}


