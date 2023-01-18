//
//  BookResponse.swift
//  BookApp
//
//  Created by apprenant1 on 18/01/2023.
//

import Foundation

struct BookResponse: Codable {
    let items: [Item]
}

struct Item: Codable, Identifiable {
    var id: String
    var etag: String
    var volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
}
struct ImageLinks: Codable {
    let thumbnail: String
}
