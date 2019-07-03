//
//  DataPool.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 12/05/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import RxSwift
import Alamofire

protocol DataPool {
    associatedtype DataRequest: URLRequestConvertible

    func decodedData<D: Decodable>(from request: DataRequest) -> Single<D>
}

extension DataPool {

    func decodedData<D: Decodable>(from request: DataRequest) -> Single<D> {
        return SessionManager.default.rx.decodedData(from: request)
    }

}
