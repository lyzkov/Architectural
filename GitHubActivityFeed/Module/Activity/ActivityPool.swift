//
//  ActivityPool.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 27/06/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import RxSwift
import RxStorm
import Identity

final class ActivityPool: DataPool {
    typealias DataRequest = GitHubApi.Activity

    func list(page: Int, perPage: Int) -> Single<[Activity]> {
        return Observable<[Activity]>.just((0 ..< perPage).map { _ in .fake() })
            .delay(.milliseconds(350), scheduler: MainScheduler.asyncInstance)
            .asSingle()
//        return decodedData(from: .listPublicEvents(page: page, perPage: perPage))
    }

    func list(byUserName userName: String, page: Int, perPage: Int) -> Single<[Activity]> {
        return Observable<[Activity]>.just((0 ..< perPage).map { _ in .fake() })
            .delay(.milliseconds(350), scheduler: MainScheduler.asyncInstance)
            .asSingle()
//        return decodedData(from: .listPerformedBy(userName: userName, page: page, perPage: perPage))
    }

    func filtered(byUserName userName: String, size: Int = 20, predicate: ((Activity) -> Bool)? = nil) -> Single<[Activity]> {
        func factory(page: Int) -> Observable<[Activity]> {
            let result: Observable<[Activity]>
            if userName.isEmpty {
                result = list(page: page, perPage: size).asObservable()
            } else {
                result = list(byUserName: userName, page: page, perPage: size).asObservable()
            }
            if let predicate = predicate {
                return result
                    .map { activities in
                        activities.filter(predicate)
                    }
            } else {
                return result
            }
        }

        let firstPage = factory(page: 1).asObservable().share(replay: 1)

        return Observable.interval(.seconds(0), scheduler: MainScheduler.asyncInstance)
            .map { $0 + 1 }
            .concatMap { page -> Observable<[Activity]> in
                page == 1 ? firstPage : factory(page: page).asObservable()
            }
            .takeWhile { activities in
                activities.count > 0
            }
            .scan([]) { acc, activities in
                Array(Set(acc + activities))
            }
            .skipWhile { activities in
                activities.count < size
            }
            .take(1)
            .ifEmpty(switchTo: firstPage)
            .map { Array($0.prefix(size)) }
            .asSingle()
    }

    // TODO: read interval from X-Poll-Interval HTTP header
    
    func stream(interval: RxTimeInterval = .seconds(60), size: Int = 20,
                filters: ActivityListFilters = ActivityListFilters()) -> Observable<Activity> {
        return Observable<Int>.timer(.seconds(0), period: interval, scheduler: MainScheduler.asyncInstance)
            .flatMap { [unowned self] _ -> Single<[Activity]> in
                self.filtered(byUserName: filters.userName, size: size, predicate: filters.predicate)
            }
            .flatMap {
                Observable.from($0)
            }
    }

    func bufferedStream(interval: RxTimeInterval = .seconds(60), size: Int = 20,
                        filters: ActivityListFilters = .init()) -> Observable<[Activity]> {
        return stream(interval: interval, size: size, filters: filters)
            .buffer(timeSpan: interval, count: size, scheduler: MainScheduler.asyncInstance)
            .map(Set.init)
            .map(Array.init)
    }

}

struct ActivityListFilters {
    let userName: String
    let predicate: ((Activity) -> Bool)?

    init(userName: String = "", predicate: ((Activity) -> Bool)? = nil) {
        self.userName = userName
        self.predicate = predicate
    }
}
