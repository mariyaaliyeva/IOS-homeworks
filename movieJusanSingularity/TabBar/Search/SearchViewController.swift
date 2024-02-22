//
//  SearchViewController.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 13.01.2024.
//

import UIKit
import CoreData

final class SearchViewController: UIViewController, UISearchControllerDelegate {
	
	// MARK: - Private properties
	private var networkManager = NetworkManager.shared
	
	// MARK: - Private properties
	
	private var searchMovies: [SearchResult] = [] {
		didSet {
			self.movieTableView.reloadData()
	//		hundleEmptyStateView(show: false)
		}
	}
	
	private var recomendedMovies: [RecommendedMovie] = [] {
		didSet {
			self.recomendedTableView.reloadData()
		//	hundleEmptyStateView(show: false)
		}
	}
	
	// MARK: - UI
	
	private var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Search"
		label.font = UIFont.systemFont(ofSize: 42, weight: .bold)
		return label
	}()
	
	private lazy var searchBar: UISearchBar = {
		let search = UISearchBar()
		search.delegate = self
		return search
	}()
	
	private var recomendedLabel: UILabel = {
		let label = UILabel()
		label.text = "Recomended For You"
		label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
		return label
	}()
	
	private lazy var movieTableView: UITableView = {
		var tableView = UITableView(frame: .zero, style: .grouped)
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		tableView.showsVerticalScrollIndicator = false
		tableView.dataSource = self
		tableView.delegate = self
		tableView.registerCell(MovieTableViewCell.self)
		tableView.isHidden = true
		return tableView
	}()
	
	private lazy var recomendedTableView: UITableView = {
		var tableView = UITableView(frame: .zero, style: .grouped)
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		tableView.showsVerticalScrollIndicator = false
		tableView.dataSource = self
		tableView.delegate = self
		tableView.registerCell(MovieTableViewCell.self)
		return tableView
	}()
	
	private lazy var emptyStateView: EmptyStateView = {
		let view = EmptyStateView()
		view.configure(image: UIImage(named: "search_empty")!,
									 title: "Not Found",
									 subtitle: "")
		return view
	}()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
	
		movieTableView.isHidden = true
	
		loadRecomendedMovies()
	}
	
	private func loadRecomendedMovies() {
		var movie = Int()
		let movieFromMainVC = UserDefaults.standard.integer(forKey: "movieFromMainvc")
		let favouriteMovie = UserDefaults.standard.integer(forKey: "favouriteMovies")
		let watchListMovie = UserDefaults.standard.integer(forKey: "moviesFromWatchList")
		
		if favouriteMovie != 0 {
			movie = favouriteMovie
		} else if watchListMovie != 0 {
			movie = watchListMovie
		} else {
			movie = movieFromMainVC
		}
		
		networkManager.recomendedMovie(movieId: movie) { [weak self] result in
			self?.recomendedMovies = result
		}
	}
	// MARK: - Setup Views
	private func setupViews() {
		view.backgroundColor = .white
		
		[titleLabel, searchBar, recomendedLabel, movieTableView, recomendedTableView].forEach {
			view.addSubview($0)
		}
	}
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.centerX.equalToSuperview()
		}
		
		searchBar.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
			make.leading.trailing.equalToSuperview().inset(16)
		}
		
		recomendedLabel.snp.makeConstraints { make in
			make.top.equalTo(searchBar.snp.bottom).offset(18)
			make.leading.equalToSuperview().offset(18)
			make.trailing.equalToSuperview().offset(-18)
		}
		
		movieTableView.snp.makeConstraints { make in
			make.top.equalTo(searchBar.snp.bottom).offset(12)
			make.leading.trailing.bottom.equalToSuperview()
		}
		
		recomendedTableView.snp.makeConstraints { make in
			make.top.equalTo(recomendedLabel.snp.bottom).offset(12)
			make.leading.trailing.bottom.equalToSuperview()
		}
		
//		emptyStateView.snp.makeConstraints { make in
//			make.edges.equalTo(movieTableView)
//		}
	}
	// MARK: - Private
	
	private func hundleEmptyStateView(show: Bool) {
		emptyStateView.isHidden = !show
	}
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		guard let query = searchBar.text,
					!query.trimmingCharacters(in: .whitespaces).isEmpty,
					query.trimmingCharacters(in: .whitespaces).count >= 2
		else {
			return
		}
		
		networkManager.searchMovie(with: query) { [weak self] result in
			switch result {
				
			case .success(let result):
				self?.searchMovies = result
				self?.movieTableView.isHidden = false
				self?.recomendedLabel.isHidden = true
				self?.recomendedTableView.isHidden = true
			case .failure(_):
				break
			}
		}
	}
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == movieTableView {
			return searchMovies.count
		} else {
			return recomendedMovies.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if tableView == movieTableView {
			let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MovieTableViewCell
			let movie = searchMovies[indexPath.row]
			cell.configureForSearch(movie)
			cell.configureStar()
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MovieTableViewCell
			let movie = recomendedMovies[indexPath.row]
			cell.configureForRecomended(movie)
			cell.configureStar()
			return cell
		}
	}
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView == movieTableView {
			let movieDetailsController = DetailViewController()
			let movie = searchMovies[indexPath.row]
			movieDetailsController.movieID = movie.id
			self.navigationController?.pushViewController(movieDetailsController, animated: true)
		} else {
			let movieDetailsController = DetailViewController()
			let movie = recomendedMovies[indexPath.row]
			movieDetailsController.movieID = movie.id
			self.navigationController?.pushViewController(movieDetailsController, animated: true)
		}
	}
}
