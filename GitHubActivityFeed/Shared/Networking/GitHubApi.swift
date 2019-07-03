//
//  GitHubApi.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 27/06/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Alamofire

struct GitHubApi: RestAPI {

    static var base: APIConfiguration = APIConfiguration(url: "https://api.github.com")

    enum Activity: URLRequestConvertible {
        case listPublicEvents(page: Int, perPage: Int)

        func asURLRequest() throws -> URLRequest {
            switch self {
            case let .listPublicEvents(page, perPage):
                return try ListPublic(page: page, perPage: perPage).asURLRequest()
            }
        }

        private struct ListPublic: GetEndpoint, Resource {
            typealias Result = [GitHubActivityFeed.Activity]

            static var api: RestAPI.Type = GitHubApi.self
            let path: String = "/events"

            let page: Int
            let perPage: Int
        }

    }

}
