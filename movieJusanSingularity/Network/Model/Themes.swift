//
//  Themes.swift
//  movieJusanSingularity
//
//  Created by Rustam Aliyev on 11.01.2024.
//

import Foundation

enum Themes: String, CaseIterable {
	case nowPlaying = "Now Playing"
	case popular = "Popular"
	case upcoming = "Upcoming"
	case topRated = "Top Rated"
	
	var key: String {
		return rawValue
	}
	
	var urlPath: String {
		switch self {
		case .nowPlaying:
			return "now_playing"
		case .popular:
			return "popular"
		case .upcoming:
			return "upcoming"
		case .topRated:
			return "top_rated"
		}
	}
}
