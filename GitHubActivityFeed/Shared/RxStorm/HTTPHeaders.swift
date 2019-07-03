//
//  HTTPHeaders.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 11/05/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

enum ContentType: String {
    case json = "application/json"
}

enum HTTPHeaderKey: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}
