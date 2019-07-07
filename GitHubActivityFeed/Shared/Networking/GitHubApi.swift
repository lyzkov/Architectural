//
//  GitHubApi.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 27/06/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import RxStorm
import Alamofire

struct GitHubApi: RestAPI {

    static var base: APIConfiguration = APIConfiguration(url: "https://api.github.com")

    enum Activity: URLRequestConvertible {
        case listPublicEvents(page: Int, perPage: Int)
        case listPerformedBy(userName: String, page: Int, perPage: Int)

        func asURLRequest() throws -> URLRequest {
            switch self {
            case let .listPublicEvents(page, perPage):
                return try ListPublic(page: page, perPage: perPage).asURLRequest()
            case let .listPerformedBy(userName, page, perPage):
                return try ListPerformedBy(userName: userName, page: page, perPage: perPage).asURLRequest()
            }
        }

        private struct ListPublic: GetEndpoint, Resource {
            typealias Result = [GitHubActivityFeed.Activity]

            static var api: RestAPI.Type = GitHubApi.self
            let path: String = "/events"

            let page: Int
            let perPage: Int

            var parameters: Parameters {
                return [
                    "page": page,
                    "perPage": perPage
                ]
            }
        }

        private struct ListPerformedBy: GetEndpoint, Resource {
            typealias Result = [GitHubActivityFeed.Activity]

            static var api: RestAPI.Type = GitHubApi.self
            var path: String {
                return "/users/\(userName)/events"
            }

            let userName: String
            let page: Int
            let perPage: Int

            var parameters: Parameters {
                return [
                    "page": page,
                    "perPage": perPage
                ]
            }
        }

    }

}
