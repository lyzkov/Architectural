//
//  Endpoint.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 11/05/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Alamofire

protocol Endpoint: URLRequestConvertible {
    static var api: RestAPI.Type { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders { get }
}

protocol Resource {
    associatedtype Result: Decodable
}

extension Endpoint {

    var headers: HTTPHeaders {
        return [:]
    }

    var parameters: Parameters {
        return [:]
    }

}

extension Endpoint {

    func asURLRequest() throws -> URLRequest {
        let base = Self.api.base

        return request(
            base.url + path,
            method: method,
            parameters: base.parameters + parameters,
            encoding: encoding,
            headers: base.headers + headers
            ).request!
    }

}

protocol GetEndpoint: Endpoint {
}

extension GetEndpoint {

    var method: HTTPMethod {
        return .get
    }

    var encoding: ParameterEncoding {
        return URLEncoding.default
    }

}
