//
//  Photos.swift
//  RoadTrip
//
//  Created by Angelique Babin on 02/09/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

// MARK: - Photos
struct Photos: Decodable {
    let results: [PhotosResult]

    enum CodingKeys: String, CodingKey {
        case results
    }
}

// MARK: - PhotosResult
struct PhotosResult: Decodable {
    let id: String
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case id
        case urls
    }
}

// MARK: - Urls
struct Urls: Decodable {
    let raw, full, regular, small: String
    let thumb: String
}
