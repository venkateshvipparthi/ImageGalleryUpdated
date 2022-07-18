//
//  URLRequest+Extension.swift
//  ImageGallery
//
//  Created by Venkat on 18/07/22.
//

import Foundation

extension URLRequest {
    static func getURLRequest(for apiRequest:Requestable)-> URLRequest? {
        guard let url = URL(string:apiRequest.baseUrl.appending(apiRequest.path)),
           var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        let queryItems = apiRequest.params.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        urlComponents.queryItems = queryItems
        let urlRequest = URLRequest(url: urlComponents.url!)
        return urlRequest
    }
}

