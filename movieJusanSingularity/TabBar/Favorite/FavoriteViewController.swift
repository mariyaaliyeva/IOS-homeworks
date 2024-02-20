//
//  FavoriteViewController.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 13.01.2024.
//

import UIKit
import SnapKit
import CoreData

final class FavoriteViewController: UIViewController {
	
	// MARK: - Private properties
	private var favouriteMovies: [NSManagedObject] = [] {
		didSet {
			self.movieTableView.reloadData()
		}
	}
	
	// MARK: - UI
	private var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Favorite"
		label.font = UIFont.systemFont(ofSize: 42, weight: .bold)
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
		return tableView
	}()
	
	private lazy var emptyStateView: EmptyStateView = {
		let view = EmptyStateView()
		view.isHidden = true
		view.configure(image: UIImage(named: "favourites_empty")!, title: "No Favourites", subtitle: "You haven’t liked any items yet.")
		return view
	}()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		loadMovies()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if favouriteMovies.count <= 0 {
			hundleEmptyStateView(show: true)
		} else {
			hundleEmptyStateView(show: false)
		}
	}
	
	// MARK: - Core
	private func loadMovies() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		let managedContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
		
		do {
			favouriteMovies = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. Error: \(error)")
		}
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		view.backgroundColor = .white
		
		[titleLabel, movieTableView, emptyStateView].forEach {
			view.addSubview($0)
		}
	}
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.centerX.equalToSuperview()
		}
		
		movieTableView.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(16)
			make.leading.trailing.bottom.equalToSuperview()
		}
		
		emptyStateView.snp.makeConstraints { make in
			make.edges.equalTo(view)
		}
	}
	
	// MARK: - Private
	
	private func hundleEmptyStateView(show: Bool) {
		emptyStateView.isHidden = !show
	}
}
// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return favouriteMovies.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MovieTableViewCell
		let movie = favouriteMovies[indexPath.row]
		let title = movie.value(forKeyPath: "title") as? String
		let posterPath = movie.value(forKeyPath: "posterPath") as? String
		cell.configureFavouriteMovie(with: title ?? "", and: posterPath ?? "")
		
		let isFavoriteMovie = !self.favouriteMovies.filter({
			($0.value(forKeyPath: "id") as? Int) == movie.value(forKeyPath: "id") as? Int
		}).isEmpty
		cell.toggleFavouriteImage(with: isFavoriteMovie)
		return cell
	}
}

// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let movieDetailsController = DetailViewController()
		let movie = favouriteMovies[indexPath.row]
		let id = movie.value(forKeyPath: "id") as? Int
		movieDetailsController.movieID = id ?? 0
		self.navigationController?.pushViewController(movieDetailsController, animated: true)
	}
}
