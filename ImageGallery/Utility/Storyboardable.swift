//
//  Storyboardable.swift
//  ImageGallery
//
//  Created by Venkat on 15/07/22.
//

import Foundation
import UIKit

protocol Storyboardable: AnyObject {
    static var viewControllerName: String { get }
}

extension Storyboardable where Self: UIViewController {
    static var viewControllerName: String {
        return String(describing: self)
    }

    static func storyboardViewController() -> Self {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)

        guard let vc = storyboard.instantiateViewController(withIdentifier: viewControllerName) as? Self else {
            fatalError("Could not instantiate initial storyboard with name: \(viewControllerName)")
        }
        return vc
    }
}

extension UIViewController: Storyboardable { }
