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
		let genreIDS: [Int]
		let id: Int
		let posterPath, title: String

		enum CodingKeys: String, CodingKey {
				case adult
				case genreIDS = "genre_ids"
				case id
				case posterPath = "poster_path"
				case title
		}
}
