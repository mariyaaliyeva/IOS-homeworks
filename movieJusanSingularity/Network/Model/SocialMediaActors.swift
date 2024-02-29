//
//  SocialMediaActors.swift
//  movieJusanSingularity
//
//  Created by Rustam Aliyev on 29.12.2023.
//

//   let socialMediaActors = try? JSONDecoder().decode(SocialMediaActors.self, from: jsonData)

import Foundation

// MARK: - SocialMediaActors
struct SocialMediaActors: Codable {
	let id: Int
	let imdbID: String
	let instagramID: String
	
	enum CodingKeys: String, CodingKey {
		case id
		case imdbID = "imdb_id"
		case instagramID = "instagram_id"
	}
}
