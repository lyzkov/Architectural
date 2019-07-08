//
//  FatalErrorShooter.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 09/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import SinkEmAll

protocol FatalError: Error {
    var shouldCrash: Bool { get }
}

final class FatalErrorShooter: ErrorShooting {

    func shoot(error: FatalError, attempt: Int, complete: @escaping (Shot) -> Void) {
        print("Fatal error: \(error.localizedDescription)")
        #if DEBUG
        return complete(error.shouldCrash ? .hit(error) : .sink)
        #else
        return complete(.sink)
        #endif
    }

}
