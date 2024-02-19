//
//  Images.swift
//  movieJusanSingularity
//
//  Created by Rustam Aliyev on 28.12.2023.
//

//   let images = try? JSONDecoder().decode(Images.self, from: jsonData)

import Foundation

// MARK: - Images
struct Images: Codable {
	let id: Int
	let profiles: [Profile]
}

// MARK: - Profile
struct Profile: Codable {
	let filePath: String
	
	enum CodingKeys: String, CodingKey {
		case filePath = "file_path"
	}
}

