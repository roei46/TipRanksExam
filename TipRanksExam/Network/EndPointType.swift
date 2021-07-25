//
//  EndPointType.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 22/07/2021.
//

import Foundation

protocol EndpointType {
    
    var baseURL: URL { get }
    
    var path: String { get }
    
}
