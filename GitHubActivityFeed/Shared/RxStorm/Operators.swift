//
//  Operators.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 12/05/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Alamofire

func + (url: URL, path: String) -> URL {
    return url.appendingPathComponent(path)
}

func + (defaults: Parameters, custom: Parameters) -> Parameters {
    return defaults.merging(custom, uniquingKeysWith: { _, new in new })
}

func + (defaults: HTTPHeaders, custom: HTTPHeaders) -> HTTPHeaders {
    return defaults.merging(custom, uniquingKeysWith: { _, new in new })
}
