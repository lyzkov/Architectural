//
//  Renderable.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 06/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import RxSwift

protocol Renderable {
    
}

protocol ListRendering: class {
    associatedtype Item: Renderable

    var items: (Observable<[Item]>) -> Disposable { get }
}

extension ObservableConvertibleType {

    func render<Renderer: ListRendering>(with renderer: Renderer) -> Disposable where Element == [Renderer.Item] {
            return asDriver(onErrorJustReturn: []).drive(renderer.items)
    }

}
