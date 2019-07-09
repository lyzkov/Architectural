//
//  Errors.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 09/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Alamofire
import SinkEmAll

protocol SkippableError: Error {
    var canSkip: Bool { get }
}

extension AFError: AlertError, SkippableError {

    var canSkip: Bool {
        return responseCode == 404
    }

    public var canRetry: Bool {
        switch responseCode {
        case 403?:
            return false
        case (400 ..< 599)?:
            return true
        default:
            return false
        }
    }

    // TODO: detailed info from http response body

    var description: String {
        switch responseCode {
        case 403?:
            return "API rate limit exceeded. Please try again later..."
        default:
            return "Uups! Something went wrong."
        }
    }

}

extension DecodingError: FatalError {

    var shouldCrash: Bool {
        return true
    }

}
