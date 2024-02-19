//
//  Genres.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 22.12.2023.
//

import Foundation

struct Genre: Decodable {
		var id: Int
		var name: String
}

struct GenresEntity: Decodable {
		let genres: [Genre]
}
