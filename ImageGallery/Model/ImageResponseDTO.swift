//
//  ImageEntity.swift
//  ImageGallery
//
//  Created by Venkat on 28/04/2022.
//

import Foundation

struct ImageResponseDTO: Codable {
    let photos: Photos
    let stat: String
}

struct Photos: Codable {
    let photo: [Photo]
}

struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}


// MARK: - Mappings to Domain

extension ImageResponseDTO {
    func toDomain() -> [PhotoRecord] {
        return photos.photo.map {
            PhotoRecord(name:$0.title, url: "\(APIURLs.imagesBaseUrl)/\($0.server)/\($0.id)_\($0.secret)_w.jpg")
            }
    }
}
