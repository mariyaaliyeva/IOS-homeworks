//
//  Recomended.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 29.02.2024.
//

import Foundation

// MARK: - Recommended
struct Recommended: Codable {
	let page: Int
	let results: [RecommendedResult]
	let totalPages, totalResults: Int
	
	enum CodingKeys: String, CodingKey {
		case page, results
		case totalPages = "total_pages"
		case totalResults = "total_results"
	}
}

// MARK: - RecommendedResult
struct RecommendedResult: Codable {
	let adult: Bool?
	let id: Int?
	let title, originalLanguage: String?
	let posterPath: String?
	
	enum CodingKeys: String, CodingKey {
		case adult
		case id, title
		case originalLanguage = "original_language"
		case posterPath = "poster_path"
	}
}

