//
//  ForYouViewController.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 13.01.2024.
//

import UIKit
import CoreData

final class WatchListViewController: UIViewController {

	// MARK: - Private properties
	private var moviesFromWatchList: [NSManagedObject] = [] {
		didSet {
			self.movieTableView.reloadData()
		}
	}
	
	// MARK: - UI
	private var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Watch List"
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
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		loadMovies()
		self.tabBarController?.tabBar.isHidden = false
	}
	
	// MARK: - Core
	private func loadMovies() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		let managedContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WatchListMovie")
		do {
			moviesFromWatchList = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. Error: \(error)")
		}
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		view.backgroundColor = .white
		
		[titleLabel, movieTableView].forEach {
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
	}
}
// MARK: - UITableViewDataSource
extension WatchListViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return moviesFromWatchList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MovieTableViewCell
		let movie = moviesFromWatchList[indexPath.row]
		let title = movie.value(forKeyPath: "title") as? String
		let posterPath = movie.value(forKeyPath: "posterPath") as? String
		cell.configureFavouriteMovie(with: title ?? "", and: posterPath ?? "")
		cell.configureStar()
		return cell
	}
}

// MARK: - UITableViewDelegate
extension WatchListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let movieDetailsController = DetailViewController()
		let movie = moviesFromWatchList[indexPath.row]
		let id = movie.value(forKeyPath: "id") as? Int
		movieDetailsController.movieID = id ?? 0
		self.navigationController?.pushViewController(movieDetailsController, animated: true)
	}
}
