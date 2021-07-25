//
//  Post.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 22/07/2021.
//

import Foundation

struct Posts: Codable {
    var data: [Post]
}

struct PostsData: Codable {
    var post: String
}

struct Post: Codable {
    var id: Int
    var date: String
    var title: String
    var description: String
    var link: String
    var image: Image
    var thumbnail: Thumbnail
    var author: Author
}

struct Author: Codable {
    var name: String
}

struct Image: Codable {
    var src: String
    var width: Int
    var height: Int
}

struct Thumbnail: Codable {
    var src: String
}
