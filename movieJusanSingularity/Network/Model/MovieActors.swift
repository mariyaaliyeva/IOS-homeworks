//
//  MovieActors.swift
//  movieJusanSingularity
//
//  Created by Rustam Aliyev on 28.12.2023.
//

//   let movieActors = try? JSONDecoder().decode(MovieActors.self, from: jsonData)

import Foundation

// MARK: - MovieActors
struct MovieActors: Codable {
	let cast: [Cast]
	let id: Int
}

// MARK: - Cast
struct Cast: Codable {
	let id: Int
	let posterPath: String?
	let releaseDate, title: String
	
	enum CodingKeys: String, CodingKey {
		case id
		case posterPath = "poster_path"
		case releaseDate = "release_date"
		case title
	}
}


