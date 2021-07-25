//
//  PostsViewModel.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 22/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

enum CellType {
    case post(model: PostTableViewCellViewModel)
    case promotion(title: String)
}

final class PostsViewModel {
    let disposeBag = DisposeBag()
    
    var networking: Networking!
    var isLoading: Driver<Bool>!
    var itemsDriver: Driver<[CellType]>!
    
    var searchButtonTapped = PublishRelay<Void>()
    var searchText = PublishRelay<String>()
    var loadMore = PublishRelay<Void>()
    var selectedCell = PublishRelay<CellType>()
    
    private let _onNext = PublishRelay<String>()
    lazy var onNext = _onNext.asDriver(onErrorDriveWith: .never())
    
    private var _onError: Observable<Error>!
    lazy var onError = _onError.asDriver(onErrorDriveWith: .never())
        
    var listFinished = PublishRelay<Bool>()
    
    var needReset = false
    var page = 1
    var counter = 0
    var params = [ "page": 1,
                   "per_page": 20,
                   "search_query": ""] as [String : Any]
    
    init(networking: Networking = Networking()) {
        self.networking = networking
        
        selectedCell.subscribe(onNext: { item in
            var link = ""
            switch item {
            case .post(model: let vm):
                link = vm.link
            case .promotion(title: _):
                link = "https://www.tipranks.com/"
            }
            self._onNext.accept(link)
        }).disposed(by: disposeBag)
        
        searchButtonTapped.subscribe(onNext: { [weak self] value in
            self?.page = 0
            self?.counter = 0
            self?.needReset = true
            self?.loadMore.accept(())
        }).disposed(by: disposeBag)

        searchText.subscribe(onNext: { [weak self] value in
            self?.params.updateValue(value, forKey: "search_query")
        }).disposed(by: disposeBag)
        
        
        let page = loadMore.scan(0) { (value, _) -> Int in
            self.page = self.page + 1
            self.params.updateValue(self.page, forKey: "page")
            return value + 1
        }
                
//        let posts = page
//            .flatMapLatest { page in
//                self.networking.preformNetworkTaskGet(
//                    endPoint: Api.get,
//                    type: Posts.self,
//                    methodType: .get,
//                    param: self.params)
//
//            }
//            .scan(into: [Post]()) { current, items in
//                if self.needReset {
//                    current = [Post]()
//                    self.needReset = false
//                }
//                current.append(contentsOf: items.data)
//                self.counter = current.count
//            }
//            .share()
        
        let posts = page
            .flatMapLatest { page in
                self.networking.preformNetworkTaskGet(
                    endPoint: Api.get,
                    type: Posts.self,
                    methodType: .get,
                    param: self.params)
                    .materialize()
            }
        
        let scan = posts.scan(into: [Post]()) { current, items in
            if let itemsArray = items.element?.data.count, itemsArray < 20 {
                
            }
            
            if self.needReset {
                current = [Post]()
                self.needReset = false
            }
            let test = items.element?.data
            current.append(contentsOf: test!)
            self.counter = current.count
        }
        .share()
        
        _onError = posts
            .compactMap {
                $0.error
            }
        
        _onError.subscribe(onNext: { error in
            if let error = error as NSError? {
                if error.code == 404 {

                }
            }
        }).disposed(by: disposeBag)
           
        let vm = scan.map {
            self.postsToCellViewModel(posts: $0)
        }

        isLoading = Observable.merge(
            posts.map { _ in true },
            vm.map { _ in false }
        )
        .asDriver(onErrorJustReturn: true)
        
        itemsDriver = vm
            .map { $0 }
            .asDriver(onErrorJustReturn: [])
    }
    
    private func postsToCellViewModel(posts: [Post]) -> [CellType] {
        var cellViewModelArray = [CellType]()
        for (index, object) in posts.enumerated() {
            if index % 10  == 3 {
                cellViewModelArray.append( CellType.promotion(title: "Promotion"))
            } else {
                let vm = PostTableViewCellViewModel(post: object)
                cellViewModelArray.append(CellType.post(model: vm))
            }
        }
        
        print(cellViewModelArray.count)
        return cellViewModelArray
    }
}
