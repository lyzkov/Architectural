//
//  Date+Formatter.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 08/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Foundation

extension Date {

    static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return formatter
    }()

    var shortFormatted: String {
        return Date.shortFormatter.string(from: self)
    }

}
