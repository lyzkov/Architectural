//
//  ActivityPool.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 27/06/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import RxSwift

final class ActivityPool: DataPool {
    typealias DataRequest = GitHubApi.Activity

    func list(page: Int, perPage: Int) -> Single<[Activity]> {
        return decodedData(from: .listPublicEvents(page: page, perPage: perPage))
    }

}
