//
//  Decode.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 11/05/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import RxSwift
import Alamofire

extension ObservableConvertibleType where Element == Data {

    func decode<Model>(with decoder: JSONDecoder) -> Observable<Model> where Model: Decodable {
        return asObservable()
            .map { data throws in
                try decoder.decode(Model.self, from: data)
        }
    }

}
