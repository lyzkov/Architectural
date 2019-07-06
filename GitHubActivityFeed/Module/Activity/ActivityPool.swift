//
//  ActivityPool.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 27/06/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import RxSwift
import RxStorm

final class ActivityPool: DataPool {
    typealias DataRequest = GitHubApi.Activity

    func list(page: Int, perPage: Int) -> Single<[Activity]> {
        return decodedData(from: .listPublicEvents(page: page, perPage: perPage))
    }

    // TODO: read interval from X-Poll-Interval HTTP header
    
    func stream(interval: RxTimeInterval = .seconds(60), size: Int = 20) -> Observable<Activity> {
        return Observable<Int>.timer(.seconds(0), period: interval, scheduler: MainScheduler.asyncInstance)
            .flatMap { [unowned self] _ in
                self.list(page: 1, perPage: size)
            }
            .flatMap {
                Observable.from($0)
            }
    }

    func bufferedStream(interval: RxTimeInterval = .seconds(60), size: Int = 20) -> Observable<[Activity]> {
        return stream(interval: interval, size: size)
            .buffer(timeSpan: interval, count: size, scheduler: MainScheduler.asyncInstance)
            .map(Set.init)
            .map(Array.init)
    }

}
