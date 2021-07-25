//
//  Networking.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 22/07/2021.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

enum MethodsType: String {
    case get
    case add
    case delete
    case update
}

extension MethodsType {
    
    var method: Alamofire.HTTPMethod {
        switch self {
        
        case .get:
            return .get
        case .add:
            return .post
        case .delete:
            return .delete
        case .update:
            return .patch
            
        }
    }
}

struct Networking: NetworkType {
    func downloadImage(url: String) -> Observable<UIImage> {
        return Observable<UIImage>.create { (observer) -> Disposable in
                AF.request(url).response{ response in
                    print(response)
                    switch response.result {
                    case .success(let responseData):
                        observer.onNext(UIImage(data: responseData!)!)
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    
    func preformNetworkTaskGet<T: Codable>(endPoint: EndpointType, type: T.Type, methodType: MethodsType, param: [String : Any]?) -> Observable<T> {
        return Observable<T>.create { (observer) -> Disposable in
            if let url = endPoint.baseURL.appendingPathComponent(endPoint.path).absoluteString.removingPercentEncoding {
                AF.request(url, method: methodType.method, parameters: param, encoding: URLEncoding.default).responseJSON  { (response) in
                    switch response.result {
                    case .failure(let error):
                        observer.onError(error)
                    case .success(_):
                        if let data = response.data {
                            let response = Response.init(data: data)
                            if let decode = response.decode(type) {
                                observer.onNext(decode)
                            } else {
                                observer.onError(NSError())
                            }
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
}

