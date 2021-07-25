//
//  PostTableViewCellViewModel.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 23/07/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class PostTableViewCellViewModel {
    var networking: Networking!
    let getImage = PublishRelay<Void>()
    let disposeBag = DisposeBag()

    var description: String
    var image: UIImage!
    var imageUrl: String
    var authorImageUrl: String
    var link: String
    var headline: String
    var authorName: String
    var date: String!
    
    init(networking: Networking = Networking(), post: Post) {
        self.networking = networking
        imageUrl = post.image.src
        authorImageUrl = post.thumbnail.src
        description = post.description.trimHTMLTags() ?? ""
        headline = post.title
        authorName = post.author.name
        link = post.link
        date = convertDate(date: post.date)
    }
    
    
    
    private func convertDate(date: String) -> String {
        let dd = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: date)!
        let test = dd.offset(from: date)
        return test
    }
}

