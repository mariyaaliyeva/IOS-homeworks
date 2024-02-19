//
//  UpComing.swift
//  movieJusanSingularity
//
//  Created by Mariy Aliyeva on 27.12.2023.
//

import Foundation


// MARK: - UpComing
struct UpComing: Codable {
		let dates: Dates
		let page: Int
		let results: [MovieResult]
		let totalPages, totalResults: Int

		enum CodingKeys: String, CodingKey {
				case dates, page, results
				case totalPages = "total_pages"
				case totalResults = "total_results"
		}
}

// MARK: - Dates
struct Dates: Codable {
		let maximum, minimum: String
}
		enum CodingKeys: String, CodingKey {
				case adult
				case backdropPath = "backdrop_path"
				case genreIDS = "genre_ids"
				case id
				case originalLanguage = "original_language"
				case originalTitle = "original_title"
				case overview, popularity
				case posterPath = "poster_path"
				case releaseDate = "release_date"
				case title, video
				case voteAverage = "vote_average"
				case voteCount = "vote_count"
		}

