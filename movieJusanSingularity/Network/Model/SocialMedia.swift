//
//  SocialMedia.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 25.12.2023.
//

//   let socialMedia = try? JSONDecoder().decode(SocialMedia.self, from: jsonData)

import Foundation

// MARK: - SocialMedia
struct SocialMedia: Codable {
	let id: Int
	let imdbID: String
	let facebookID: String?
	
	enum CodingKeys: String, CodingKey {
		case id
		case imdbID = "imdb_id"
		case facebookID = "facebook_id"
	}
}



