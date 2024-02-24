//
//  Search.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 16.02.2024.
//
//   let search = try? JSONDecoder().decode(Search.self, from: jsonData)

import Foundation

// MARK: - Search
struct Search: Codable {
		let page: Int
		let results: [SearchResult]
		let totalPages, totalResults: Int

		enum CodingKeys: String, CodingKey {
				case page, results
				case totalPages = "total_pages"
				case totalResults = "total_results"
		}
}

// MARK: - Result
struct SearchResult: Codable {
		let adult: Bool
		let backdropPath: String?
		let genreIDS: [Int]
		let id: Int
		let originalLanguage, originalTitle, overview: String
		let popularity: Double
		let posterPath: String?
		let releaseDate, title: String
		let video: Bool
		let voteAverage: Double
		let voteCount: Int

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
}
