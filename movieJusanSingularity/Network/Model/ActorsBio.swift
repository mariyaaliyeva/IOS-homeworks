//
//  Actors.swift
//  movieJusanSingularity
//
//  Created by Rustam Aliyev on 28.12.2023.
//

import Foundation


// MARK: - ActorsBio
struct ActorsBio: Codable {
	let biography, birthday: String
	let deathday: String?
	let id: Int
	let name, placeOfBirth: String
	let profilePath: String
	
	enum CodingKeys: String, CodingKey {
		case biography, birthday, deathday, id
		case name
		case placeOfBirth = "place_of_birth"
		case profilePath = "profile_path"
	}
}



