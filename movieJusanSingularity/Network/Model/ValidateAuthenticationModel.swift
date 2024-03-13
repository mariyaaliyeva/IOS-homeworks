//
//  ValidateAuthenticationModel.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 28.02.2024.
//

import Foundation

struct ValidateAuthenticationModel: Encodable {
	let username: String
	let password: String
	let requestToken: String
	
	enum CodingKeys: String, CodingKey {
		case username
		case password
		case requestToken = "request_token"
	}
	
	func toDictionary() -> [String: Any] {
		return [
			"username": self.username,
			"password": self.password,
			"request_token": self.requestToken
		]
	}
}
