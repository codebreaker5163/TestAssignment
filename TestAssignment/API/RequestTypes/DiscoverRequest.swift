//
//  DiscoverRequest.swift
//  TestAssignment
//
//  Created by Himanshu Sharma on 15/08/25.
//

import Foundation

struct DiscoverRequest: Encodable {
    var includeAdult: Bool = false
    var includeVideo: Bool = false
    var language:String = "en-US"
    var page: Int = 1
    var sortBy: String = "popularity.desc"
}
