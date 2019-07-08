//
//  ActivityDetailsCyclone.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 07/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import RxSwift
import RxCyclone

final class ActivityDetailsCyclone: Cyclone {

    struct State: ReducibleState {

        enum Event: EventType {
            case load(activity: Activity)
        }

        let activity: Activity?

        static var initial: State = .init(activity: nil)

        static func reduce(state: State, event: Event) -> State {
            switch event {
            case .load(let activity):
                return .init(activity: activity)
            }
        }

    }

    // MARK: - Inputs

    let activity = ReplaySubject<Activity>.create(bufferSize: 1)

    // MARK: - Outputs

    lazy var output = state(from: activity.map(Event.load(activity:)))

    lazy var activityDetails = output[\.activity]
        .compactMap { $0.map(ActivityDetails.init(from:)) }

}
