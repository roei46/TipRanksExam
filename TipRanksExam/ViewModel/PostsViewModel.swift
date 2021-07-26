//
//  PostsViewModel.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 22/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

enum NetworkState {
    case footer
    case loading
    case notLoading
}

enum CellType {
    case post(model: PostTableViewCellViewModel)
    case promotion(title: String)
}

final class PostsViewModel {
    
    let disposeBag = DisposeBag()
    private var networking: Networking!
    
    //Inputs
    var searchButtonTapped = PublishRelay<Void>()
    var searchText = PublishRelay<String>()
    var loadMore = PublishRelay<Void>()
    var selectedCell = PublishRelay<CellType>()
    
    //Outputs
    var itemsDriver: Driver<[CellType]>!
    var isLoadingState = PublishRelay<NetworkState>()
    var isLoading: Driver<NetworkState>!
    private let _onNext = PublishRelay<String>()
    lazy var onNext = _onNext.asDriver(onErrorDriveWith: .never())
    
    private var _onError: Observable<Error>!
    lazy var onError = _onError.asDriver(onErrorDriveWith: .never())
    
    private var needReset = false
    private var page = 1
    var counter = 0
    private var params = [ "page": 1,
                   "per_page": 20,
                   "search_query": ""] as [String : Any]
    
    init(networking: Networking = Networking()) {
        self.networking = networking
        
        //MARK -  Now what to do if selected item
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
                //MARK - if array < 20 show footer
                self.isLoadingState.accept(.footer)
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
        
        //MARK - if error  == 404 show footer
        _onError.subscribe(onNext: { error in
            if let errortest = error as NSError? {
                if errortest.code == 404 {
                    self.isLoadingState.accept(.footer)
                }
            }
        }).disposed(by: disposeBag)
           
        let vm = scan.map {
            self.postsToCellViewModel(posts: $0)
        }

        itemsDriver = vm
            .map { $0 }
            .asDriver(onErrorJustReturn: [])
        
        isLoading = Observable.merge(
            posts.map { _ in .loading },
            itemsDriver.asObservable().map { _ in .notLoading }
        )
        .asDriver(onErrorJustReturn: .notLoading)
    }
    
    private func postsToCellViewModel(posts: [Post]) -> [CellType] {
        //MARK - Add cells ever 10 cells 

        var cellViewModelArray = [CellType]()
        for (index, object) in posts.enumerated() {
            if index % 10  == 3 {
                cellViewModelArray.append( CellType.promotion(title: "Promotion"))
            } else {
                let vm = PostTableViewCellViewModel(post: object)
                cellViewModelArray.append(CellType.post(model: vm))
            }
        }
        
        return cellViewModelArray
    }
}
