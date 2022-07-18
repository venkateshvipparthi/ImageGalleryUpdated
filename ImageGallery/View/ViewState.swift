//
//  ViewState.swift
//  ImageGallery
//
//  Created by Venkat on 28/04/2022.
//

import Foundation

enum ViewState: Equatable {
    case none
    case loading
    case finishedLoading
    case error(String)
}
