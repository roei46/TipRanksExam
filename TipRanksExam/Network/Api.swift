//
//  Api.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 22/07/2021.
//

import Foundation

enum Api {
    case get
    case add
    case update(String)
    case delete(String)

}

extension Api: EndpointType {

    var baseURL: URL {
        return URL(string: "https://www.tipranks.com/api/news/posts")!
    }
        
    var path: String {
        switch self {
        case .get:
            return ""
        case .add:
            return ""
        case .update(let id):
            return "\(id)"
        case .delete(let id):
            return "\(id)"
        }
    }
}
