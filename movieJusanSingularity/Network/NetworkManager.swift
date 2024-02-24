//
//  MovieAPI.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 20.12.2023.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

final class NetworkManager {
	
	static var shared = NetworkManager()
	
	var apiKey: String {
		get {
			return KeychainWrapper.standard.string(forKey: "apiKey") ?? ""
		}
		set(newValue) {
			KeychainWrapper.standard.set(newValue, forKey: "apiKey")
		}
	}
	
	private let session = URLSession(configuration: .default)
	
	private let headers: HTTPHeaders = [
		"accept": "application/json",
		"Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YzIyYzEwNjdjZWM3OWRlMDgyODg5Mjg5NGUzMWJkYyIsInN1YiI6IjY1YjIzYzE3MGYyZmJkMDEzMDY2YTBiNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Mp_XUBq4oK4yBkE0QWgpQE-uhK_5ayYAdfjJPRkVyv0"
	]
	
	private lazy var urlComponents: URLComponents = {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "api.themoviedb.org"
		components.queryItems = [
			URLQueryItem(name: "api_key", value: apiKey)
		]
		return components
	}()
	
	func fetchMovie(theme: String, completion: @escaping(APIResult<[MovieResult]>)->()) {
		
		var components = urlComponents
		components.path = "/3/movie/\(theme)"
		
		guard let url = components.url else { return }
		
		var request = URLRequest(url: url)
		
		request.addValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YzIyYzEwNjdjZWM3OWRlMDgyODg5Mjg5NGUzMWJkYyIsInN1YiI6IjY1YjIzYzE3MGYyZmJkMDEzMDY2YTBiNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Mp_XUBq4oK4yBkE0QWgpQE-uhK_5ayYAdfjJPRkVyv0", forHTTPHeaderField: "Authorization")
		
		let task = session.dataTask(with: request) { data, response, error in
			guard error == nil else {
				print("Error: error calling GET")
				return
			}
			guard let data else {
				print("Error: Did not recieve data")
				return
			}
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed")
				return
			}
			
			do {
				let movie = try JSONDecoder().decode(Movie.self, from: data)
				DispatchQueue.main.async {
					completion(.success(movie.results))
				}
			} catch {
				DispatchQueue.main.async {
					completion(.failure(.unknown))
				}
			}
		}
		task.resume()
	}
	
	func fetchGenres(completion: @escaping ([Genre]) -> Void) {
		var components = urlComponents
		components.path = "/3/genre/movie/list"
		
		guard let requestUrl = components.url else {
			return
		}
		
		AF.request(requestUrl, headers: headers).responseData { response in
			guard let data = response.data else {
				print("Error: Did not receive data")
				return
			}
			
			do {
				let genresEntity = try JSONDecoder().decode(GenresEntity.self, from: data)
				DispatchQueue.main.async {
					completion(genresEntity.genres)
				}
			} catch {
				DispatchQueue.main.async {
					completion([])
				}
			}
		}
	}
	
	func fetchMovieDetails(id: Int, completion: @escaping (MovieDetailsEntity) -> Void) {
		var components = urlComponents
		components.path = "/3/movie/\(id)"
		
		guard let requestUrl = components.url else {
			return
		}
		
		let task = session.dataTask(with: requestUrl) { data, response, error in
			guard error == nil else {
				print("Error: error calling GET")
				return
			}
			
			guard let data else {
				print("Error: Did not recieve data")
				
				return
			}
			
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed")
				return
			}
			
			do {
				let movieDetails = try JSONDecoder().decode(MovieDetailsEntity.self, from: data)
				DispatchQueue.main.async {
					completion(movieDetails)
				}
			} catch {
				DispatchQueue.main.async {
					print("No json!")
				}
			}
		}
		task.resume()
	}
	
	func fetchVideos(id: Int, completion: @escaping ([Video]) -> Void) {
		var components = urlComponents
		components.path = "/3/movie/\(id)/videos"
		
		guard let requestUrl = components.url else {
			return
		}
		
		let task = session.dataTask(with: requestUrl) { data, response, error in
			guard error == nil else {
				print("Error: error calling GET")
				return
			}
			
			guard let data else {
				print("Error: Did not recieve data")
				return
			}
			
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed")
				return
			}
			
			do {
				let videoDetails = try JSONDecoder().decode(VideoEntity.self, from: data)
				DispatchQueue.main.async {
					completion(videoDetails.results)
				}
			} catch {
				DispatchQueue.main.async {
					print("No json!")
				}
			}
		}
		task.resume()
	}
	
	func fetchImdb(id: Int, completion: @escaping (SocialMedia) -> Void) {
		var components = urlComponents
		components.path = "/3/movie/\(id)/external_ids"
		
		guard let requestUrl = components.url else {
			return
		}
		
		var request = URLRequest(url: requestUrl)
		
		request.addValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YzIyYzEwNjdjZWM3OWRlMDgyODg5Mjg5NGUzMWJkYyIsInN1YiI6IjY1YjIzYzE3MGYyZmJkMDEzMDY2YTBiNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Mp_XUBq4oK4yBkE0QWgpQE-uhK_5ayYAdfjJPRkVyv0", forHTTPHeaderField: "Authorization")
		
		let task = session.dataTask(with: requestUrl) { data, response, error in
			guard error == nil else {
				print("Error: error calling GET")
				return
			}
			
			guard let data else {
				print("Error: Did not recieve data")
				
				return
			}
			
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed")
				return
			}
			
			do {
				let socialMedia = try JSONDecoder().decode(SocialMedia.self, from: data)
				DispatchQueue.main.async {
					completion(socialMedia)
				}
			} catch {
				DispatchQueue.main.async {
					print("No json!")
				}
			}
		}
		task.resume()
	}
	
	func fetchCast(id: Int, completion: @escaping ([Actors]) -> Void) {
		var components = urlComponents
		components.path = "/3/movie/\(id)/credits"
		
		guard let requestUrl = components.url else {
			return
		}
		
		var request = URLRequest(url: requestUrl)
		
		request.addValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YzIyYzEwNjdjZWM3OWRlMDgyODg5Mjg5NGUzMWJkYyIsInN1YiI6IjY1YjIzYzE3MGYyZmJkMDEzMDY2YTBiNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Mp_XUBq4oK4yBkE0QWgpQE-uhK_5ayYAdfjJPRkVyv0", forHTTPHeaderField: "Authorization")
		
		let task = session.dataTask(with: requestUrl) { data, response, error in
			guard error == nil else {
				print("Error: error calling GET")
				return
			}
			
			guard let data else {
				print("Error: Did not recieve data")
				return
			}
			
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed")
				return
			}
			
			do {
				let castDetails = try JSONDecoder().decode(CastEntity.self, from: data)
				DispatchQueue.main.async {
					completion(castDetails.cast)
				}
			} catch {
				DispatchQueue.main.async {
					print("No json!")
				}
			}
		}
		task.resume()
	}
	
	func fetchBioActors(id: Int, completion: @escaping (ActorsBio) -> Void) {
		var components = urlComponents
		components.path = "/3/person/\(id)"
		
		guard let requestUrl = components.url else {
			return
		}
		
		var request = URLRequest(url: requestUrl)
		
		request.addValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YzIyYzEwNjdjZWM3OWRlMDgyODg5Mjg5NGUzMWJkYyIsInN1YiI6IjY1YjIzYzE3MGYyZmJkMDEzMDY2YTBiNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Mp_XUBq4oK4yBkE0QWgpQE-uhK_5ayYAdfjJPRkVyv0", forHTTPHeaderField: "Authorization")
		
		let task = session.dataTask(with: requestUrl) { data, response, error in
			guard error == nil else {
				print("Error: error calling GET")
				return
			}
			
			guard let data else {
				print("Error: Did not recieve data")
				return
			}
			
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed")
				return
			}
			
			do {
				let bioDetails = try JSONDecoder().decode(ActorsBio.self, from: data)
				DispatchQueue.main.async {
					completion(bioDetails)
				}
			} catch {
				DispatchQueue.main.async {
					print("No json!")
				}
			}
		}
		task.resume()
	}
	
	func fetchImagesActors(id: Int, completion: @escaping ([Profile]) -> Void) {
		var components = urlComponents
		components.path = "/3/person/\(id)/images"
		
		guard let requestUrl = components.url else {
			return
		}
		
		var request = URLRequest(url: requestUrl)
		
		request.addValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YzIyYzEwNjdjZWM3OWRlMDgyODg5Mjg5NGUzMWJkYyIsInN1YiI6IjY1YjIzYzE3MGYyZmJkMDEzMDY2YTBiNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Mp_XUBq4oK4yBkE0QWgpQE-uhK_5ayYAdfjJPRkVyv0", forHTTPHeaderField: "Authorization")
		
		let task = session.dataTask(with: requestUrl) { data, response, error in
			guard error == nil else {
				print("Error: error calling GET")
				return
			}
			
			guard let data else {
				print("Error: Did not recieve data")
				return
			}
			
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed")
				return
			}
			
			do {
				let imagesDetails = try JSONDecoder().decode(Images.self, from: data)
				DispatchQueue.main.async {
					completion(imagesDetails.profiles)
				}
			} catch {
				DispatchQueue.main.async {
					print("No json!")
				}
			}
		}
		task.resume()
	}
	
	func fetchMovieActors(id: Int, completion: @escaping ([Cast]) -> Void) {
		var components = urlComponents
		components.path = "/3/person/\(id)/movie_credits"
		
		guard let requestUrl = components.url else {
			return
		}
		
		var request = URLRequest(url: requestUrl)
		
		request.addValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YzIyYzEwNjdjZWM3OWRlMDgyODg5Mjg5NGUzMWJkYyIsInN1YiI6IjY1YjIzYzE3MGYyZmJkMDEzMDY2YTBiNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Mp_XUBq4oK4yBkE0QWgpQE-uhK_5ayYAdfjJPRkVyv0", forHTTPHeaderField: "Authorization")
		
		let task = session.dataTask(with: requestUrl) { data, response, error in
			guard error == nil else {
				print("Error: error calling GET")
				return
			}
			
			guard let data else {
				print("Error: Did not recieve data")
				return
			}
			
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed")
				return
			}
			
			do {
				let imagesDetails = try JSONDecoder().decode(MovieActors.self, from: data)
				DispatchQueue.main.async {
					completion(imagesDetails.cast)
				}
			} catch {
				DispatchQueue.main.async {
					print("No json!")
				}
			}
		}
		task.resume()
	}
	
	func fetchSocialMediaActors(id: Int, completion: @escaping (SocialMediaActors) -> Void) {
		var components = urlComponents
		components.path = "/3/person/\(id)/external_ids"
		
		guard let requestUrl = components.url else {
			return
		}
		
		var request = URLRequest(url: requestUrl)
		
		request.addValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YzIyYzEwNjdjZWM3OWRlMDgyODg5Mjg5NGUzMWJkYyIsInN1YiI6IjY1YjIzYzE3MGYyZmJkMDEzMDY2YTBiNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Mp_XUBq4oK4yBkE0QWgpQE-uhK_5ayYAdfjJPRkVyv0", forHTTPHeaderField: "Authorization")
		
		let task = session.dataTask(with: requestUrl) { data, response, error in
			guard error == nil else {
				print("Error: error calling GET")
				return
			}
			
			guard let data else {
				print("Error: Did not recieve data")
				return
			}
			
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed")
				return
			}
			
			do {
				let socialMediaActorsDetails = try JSONDecoder().decode(SocialMediaActors.self, from: data)
				DispatchQueue.main.async {
					completion(socialMediaActorsDetails)
				}
			} catch {
				DispatchQueue.main.async {
					print("No json!")
				}
			}
		}
		task.resume()
	}
	
	func getRequestToken(completion: @escaping (APIResult<RequestTokenModel>) -> Void) {
		var components = urlComponents
		components.path = "/3/authentication/token/new"
		components.queryItems = nil
		
		guard let requestUrl = components.url else {
			completion(.failure(.unknown))
			return
		}
		
		AF.request(requestUrl, headers: headers).responseData { response in
			switch response.result {
			case .success(let data):
				print(response)
				do {
					let requestTokenModel = try JSONDecoder().decode(RequestTokenModel.self, from: data)
					completion(.success(requestTokenModel))
				} catch {
					completion(.failure(.incorectJson))
				}
			case .failure:
				completion(.failure(.unknown))
			}
		}
	}
	
	func validateWithLogin(requestBody: [String: Any], completion: @escaping (APIResult<RequestTokenModel>) -> Void) {
		var components = urlComponents
		components.path = "/3/authentication/token/validate_with_login"
		var requestHeaders = headers
		requestHeaders["Content-Type"] = "application/json"
		
		guard let requestUrl = components.url else {
			completion(.failure(.unknown))
			return
		}
		
		AF.request(
			requestUrl,
			method: .post,
			parameters: requestBody,
			encoding: JSONEncoding.default,
			headers: requestHeaders
		).responseData { response in
			switch response.result {
			case .success(let data):
				do {
					let requestTokenModel = try JSONDecoder().decode(RequestTokenModel.self, from: data)
					completion(.success(requestTokenModel))
				} catch {
					completion(.failure(.incorectJson))
				}
			case .failure:
				completion(.failure(.unknown))
			}
		}
	}
	
	func createSession(requestBody: [String: Any], completion: @escaping (APIResult<String>) -> Void) {
		var components = urlComponents
		components.path = "/3/authentication/session/new"
		
		var requestHeaders = headers
		requestHeaders["Content-Type"] = "application/json"
		
		guard let requestUrl = components.url else {
			completion(.failure(.unknown))
			return
		}
		
		AF.request(
			requestUrl,
			method: .post,
			parameters: requestBody,
			encoding: JSONEncoding.default,
			headers: requestHeaders
		).responseData { response in
			switch response.result {
			case .success(let data):
				do {
					if
						let responseData = try JSONSerialization.jsonObject(
							with: data,
							options: []
						) as? [String: Any],
						let success = responseData["success"] as? Bool,
						success,
						let sessionId = responseData["session_id"] as? String
					{
						completion(.success(sessionId))
					} else {
						completion(.failure(.failedWith(reason: "Failed to create session")))
					}
				} catch {
					completion(.failure(.incorectJson))
				}
			case .failure:
				completion(.failure(.unknown))
			}
		}
	}
	
	func searchMovie(with query: String, completion: @escaping (APIResult<[SearchResult]>) -> Void) {
		var components = urlComponents
		components.path = "/3/search/movie"
		
		components.queryItems = [
			URLQueryItem.init(name: "query", value: query),
			URLQueryItem.init(name: "include_adult", value: "false"),
			URLQueryItem.init(name: "language", value: "en-US"),
			URLQueryItem.init(name: "page", value: "1")
		]
		guard let requestUrl = components.url else {
			return
		}
	
		AF.request(requestUrl, headers: headers).responseData { response in
			guard let data = response.data else {
				print("Error: Did not receive data")
				return
			}
			
			do {
				let searchResult = try JSONDecoder().decode(Search.self, from: data)
				DispatchQueue.main.async {
					completion(.success(searchResult.results))
				}
			} catch {
				DispatchQueue.main.async {
					completion(.failure(.unknown))
				}
			}
		}
	}
	
	func recomendedMovie(movieId: Int, completion: @escaping ([RecommendedMovie]) -> Void) {
		
		var components = urlComponents
		components.path = "/3/movie/\(movieId)/recommendations"
	
		guard let requestUrl = components.url else {
			return
		}
		var request = URLRequest(url: requestUrl)
		
		request.addValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YzIyYzEwNjdjZWM3OWRlMDgyODg5Mjg5NGUzMWJkYyIsInN1YiI6IjY1YjIzYzE3MGYyZmJkMDEzMDY2YTBiNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Mp_XUBq4oK4yBkE0QWgpQE-uhK_5ayYAdfjJPRkVyv0", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: requestUrl) { data, response, error in
			guard error == nil else {
				print("Error: error calling GET")
				return
			}
			
			guard let data else {
				print("Error: Did not recieve data")
				return
			}
			
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed")
				return
			}

			do {
				let recomendedMovie = try JSONDecoder().decode(Recommended.self, from: data)
				DispatchQueue.main.async {
					completion(recomendedMovie.results)
				}
			} catch {
				DispatchQueue.main.async {
					print(error)
				}
			}
		}
		task.resume()
	}
}
