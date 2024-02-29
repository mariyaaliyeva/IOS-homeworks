//
//  RequestTokenModel.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 25.01.2024.
//

import Foundation

struct RequestTokenModel: Decodable {
	let success: Bool
	let requestToken: String
	let expiresAt: String?
	
	enum CodingKeys: String, CodingKey {
		case success
		case requestToken = "request_token"
		case expiresAt = "expires_at"
	}
}

