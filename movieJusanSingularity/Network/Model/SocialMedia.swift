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
		let imdbID, wikidataID: String
		let facebookID: String?
		let instagramID, twitterID: String

		enum CodingKeys: String, CodingKey {
				case id
				case imdbID = "imdb_id"
				case wikidataID = "wikidata_id"
				case facebookID = "facebook_id"
				case instagramID = "instagram_id"
				case twitterID = "twitter_id"
		}
}



