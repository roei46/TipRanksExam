//
//  NetworkType.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 22/07/2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol NetworkType {
    func preformNetworkTaskGet<T: Codable>(endPoint: EndpointType, type: T.Type, methodType: MethodsType, param: [String : Any]?) -> Observable<T>
}
