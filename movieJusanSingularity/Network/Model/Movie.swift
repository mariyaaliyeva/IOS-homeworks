//
//  Movie.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 19.12.2023.
//

import Foundation

// MARK: - Welcome
struct Movie: Codable {
		let results: [MovieResult]

		enum CodingKeys: String, CodingKey {
				case results
		}
}

// MARK: - Result
struct MovieResult: Codable {
		let backdropPath: String?
		let genreIDS: [Int]
		let id: Int
		let originalTitle, overview, title: String
		let posterPath, releaseDate: String
		let voteAverage: Double
		let voteCount: Int

		enum CodingKeys: String, CodingKey {
				case backdropPath = "backdrop_path"
				case genreIDS = "genre_ids"
				case id, title
				case originalTitle = "original_title"
				case overview
				case posterPath = "poster_path"
				case releaseDate = "release_date"
				case voteAverage = "vote_average"
				case voteCount = "vote_count"
		}
}

