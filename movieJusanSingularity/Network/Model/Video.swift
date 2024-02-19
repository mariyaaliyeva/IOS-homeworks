//
//  Video.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 25.12.2023.
//

import Foundation

struct VideoEntity: Decodable {
		var results: [Video]
}

struct Video: Decodable {
		var key: String?
		var site: String?
}

