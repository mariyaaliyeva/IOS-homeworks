//
//  Cast.swift
//  movieJusanSingularity
//
//  Created by Rustam Aliyev on 26.12.2023.
//

import Foundation

struct Actors: Decodable {
	
	enum CodingKeys: String, CodingKey{
		case id
		case name = "name"
		case character
		case profilePath = "profile_path"
		case castID = "cast_id"
	}
	let id: Int
	let name: String?
	let profilePath: String?
  let character: String?
	let castID: Int?
}

struct CastEntity: Decodable {
	let cast: [Actors]
}
