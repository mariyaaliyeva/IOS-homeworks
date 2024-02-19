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
	let freebaseMid, freebaseID: String?
	let imdbID: String
	let tvrageID, wikidataID, facebookID: String?
	let instagramID: String
	let tiktokID, twitterID, youtubeID: String?
	
	enum CodingKeys: String, CodingKey {
		case id
		case freebaseMid = "freebase_mid"
		case freebaseID = "freebase_id"
		case imdbID = "imdb_id"
		case tvrageID = "tvrage_id"
		case wikidataID = "wikidata_id"
		case facebookID = "facebook_id"
		case instagramID = "instagram_id"
		case tiktokID = "tiktok_id"
		case twitterID = "twitter_id"
		case youtubeID = "youtube_id"
	}
}
