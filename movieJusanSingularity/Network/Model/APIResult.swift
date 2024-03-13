//
//  APIRequst.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 25.01.2024.
//
import Foundation

enum APIResult<T> {
	case success(T)
	case failure(NetworkError)
}

enum NetworkError {
	case networkFail
	case incorectJson
	case unknown
	case failedWith(reason: String)
}
