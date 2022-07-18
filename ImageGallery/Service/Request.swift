//
//  Request.swift
//  ImageGallery
//
//  Created by Venkat on 28/04/2022.
//

import Foundation

protocol Requestable {
    var baseUrl:String {get}
    var path:String {get}
    var params:[String:String] {get}
}

struct Request:Requestable {
    var baseUrl: String
    var path: String
    var params: [String : String]
}

