//
//  SearchViewController.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 13.01.2024.
//

import UIKit

final class SearchViewController: UIViewController, UISearchControllerDelegate {
	
	// MARK: - Private properties
	private var networkManager = NetworkManager.shared
	
	private var searchMovies: [SearchResult] = [] {
		didSet {
			self.movieTableView.reloadData()
			hundleEmptyStateView(show: false)
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
	
	private lazy var movieTableView: UITableView = {
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
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		view.backgroundColor = .white
		
		[titleLabel, searchBar, movieTableView, emptyStateView].forEach {
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
		
		movieTableView.snp.makeConstraints { make in
			make.top.equalTo(searchBar.snp.bottom).offset(48)
			make.leading.trailing.bottom.equalToSuperview()
		}
		
		emptyStateView.snp.makeConstraints { make in
			make.edges.equalTo(movieTableView)
		}
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
			hundleEmptyStateView(show: true)
			return
		}
		
		networkManager.searchMovie(with: query) { [weak self] result in
			self?.searchMovies = result
		}
	}
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchMovies.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MovieTableViewCell
		let movie = searchMovies[indexPath.row]
		cell.configureForSearch(movie)
		cell.configureStar()
		return cell
	}
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let movieDetailsController = DetailViewController()
		let movie = searchMovies[indexPath.row]
		movieDetailsController.movieID = movie.id
		self.navigationController?.pushViewController(movieDetailsController, animated: true)
	}
}
