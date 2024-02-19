//
//  ViewController.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 19.12.2023.
//

import UIKit
import SnapKit
import CoreData

final class MainViewController: UIViewController {
	
	var isShowGenres = false
	
	private enum Constants {
		static let collectionViewWidth: CGFloat = 150
		static let collectionViewHeight: CGFloat = 35
	}
	
	// MARK: - Private properties
	private var networkManager = NetworkManager.shared
	private var titleLabelYPosition: Constraint!
	private var allMovies: [MovieResult] = []
	private var themes = Themes.allCases
	private var favouriteMovies: [NSManagedObject] = []
	
	private lazy var genres: [Genre] = [.init(id: 1, name: "All")] {
		didSet {
			self.genresCollectionView.reloadData()
		}
	}
	
	private lazy var movie: [MovieResult] = [] {
		didSet {
			self.movieTableView.reloadData()
		}
	}
	// MARK: - UI
	private var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "MovieDB"
		label.font = UIFont.systemFont(ofSize: 42, weight: .bold)
		return label
	}()
	
	private var themeTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "Theme"
		label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
		return label
	}()
	
	private lazy var themeCollectionView: UICollectionView = {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.backgroundColor = .clear
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.reuseId)
		return collectionView
	}()
	
	private lazy var containerView = UIView()
	
	private lazy var genreStack: UIStackView = {
		let stack = UIStackView()
		stack.alignment = .leading
		stack.distribution = .fillProportionally
		stack.axis = .vertical
		return stack
	}()
	
	private lazy var genreTitleStack: UIStackView = {
		let stack = UIStackView()
		stack.alignment = .center
		stack.distribution = .fillEqually
		stack.axis = .horizontal
		return stack
	}()
	
	private var genreTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "Genre"
		label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
		return label
	}()
	
	private var genreHideButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
		button.tintColor = .black
		button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
		return button
	}()
	
	private lazy var genresCollectionView: UICollectionView = {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.backgroundColor = .clear
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.reuseId)
		return collectionView
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
		genresCollectionView.isHidden = true
		setupViews()
		setupConstraints()
		loadGenres()
		loadMovies(theme: .nowPlaying, genre: genres.first!)
		loadFavouriteMovies()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.tabBar.isHidden = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		animate()
	}
	
	// MARK: - Methods
	func hideOrShowGenres() {
		if isShowGenres == true {
			genreHideButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
			genresCollectionView.isHidden = false
		} else {
			genreHideButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
			genresCollectionView.isHidden = true
		}
	}
	
	@objc
	func tapButton() {
		isShowGenres.toggle()
		hideOrShowGenres()
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		view.backgroundColor = .white
		containerView.alpha = 0
		[titleLabel, containerView].forEach {
			view.addSubview($0)
		}
		
		[themeTitleLabel, themeCollectionView, genreStack, movieTableView].forEach {
			containerView.addSubview($0)
		}
		
		[genreTitleStack, genresCollectionView].forEach {
			genreStack.addArrangedSubview($0)
		}
		[genreTitleLabel, genreHideButton].forEach {
			genreTitleStack.addArrangedSubview($0)
		}
	}
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		
		titleLabel.snp.makeConstraints { make in
			titleLabelYPosition = make.centerY.equalToSuperview().constraint
			make.centerX.equalToSuperview()
		}
		
		containerView.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
			make.leading.trailing.bottom.equalToSuperview()
		}
		
		themeTitleLabel.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.leading.trailing.equalToSuperview().offset(4)
		}
		
		themeCollectionView.snp.makeConstraints { make in
			make.top.equalTo(themeTitleLabel.snp.bottom)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(35)
		}
		
		genreStack.snp.makeConstraints { make in
			make.top.equalTo(themeCollectionView.snp.bottom).offset(6)
			make.leading.trailing.equalToSuperview().offset(4)
		}
		
		genresCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(35)
		}
		
		movieTableView.snp.makeConstraints { make in
			make.top.equalTo(genreStack.snp.bottom).offset(4)
			make.leading.trailing.bottom.equalToSuperview()
		}
	}
	
	// MARK: - Private
	private func loadMovies(theme: Themes, genre: Genre) {
		networkManager.fetchMovie(theme: theme.urlPath) { [weak self] movies in
			self?.allMovies = movies
			self?.movie = movies
		}
	}
	
	private func loadGenres() {
		networkManager.fetchGenres { [weak self] genres in
			genres.forEach { genre in
				self?.genres.append(genre)
			}
		}
	}
	
	private func obtainMovieList(with genreId: Int) {
		
		guard genreId != 1 else {
			movie = allMovies
			return
		}
		movie = allMovies.filter { movie in
			movie.genreIDS.contains(genreId)
		}
	}
	
	// MARK: - Core
	private func loadFavouriteMovies() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let manageContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
		
		do {
			favouriteMovies = try manageContext.fetch(fetchRequest)
			movieTableView.reloadData()
		} catch let error as NSError {
			print("Could not fetch. Error: \(error)")
		}
	}
	
	private func saveFavouriteMovie(with movie: MovieResult) {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let manageContext = appDelegate.persistentContainer.viewContext
		
		guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteMovies", in: manageContext) else {return}
		let favourieMovie = NSManagedObject(entity: entity, insertInto: manageContext)
		
		favourieMovie.setValue(movie.id, forKey: "id")
		favourieMovie.setValue(movie.title, forKey: "title")
		favourieMovie.setValue(movie.posterPath, forKey: "posterPath")
		
		do {
			try manageContext.save()
		} catch let error as NSError {
			print("Could not save. Error \(error)")
		}
	}
	
	private func deleteFavouriteMovie(with movie: MovieResult) {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let manageContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
		let predicate1 = NSPredicate(format: "id == %@", "\(movie.id)")
		let predicate2 = NSPredicate(format: "title == %@", movie.title)
		let predicate3 = NSPredicate(format: "posterPath == %@", movie.posterPath)
		let predicateAll = NSCompoundPredicate(type: .and, subpredicates: [predicate1, predicate2, predicate3])
		fetchRequest.predicate = predicateAll
		
		do {
			let results = try manageContext.fetch(fetchRequest)
			let data = results.first
			if let data {
				manageContext.delete(data)
			}
			try manageContext.save()
		} catch let error as NSError {
			print("Could not save. Error \(error)")
		}
	}
	
	private func animate() {
		
		UIView.animateKeyframes(withDuration: 4, delay: 0, animations: {
			
			UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
				self.titleLabel.alpha = 1
			})
			UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.7, animations: {
				self.titleLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
			})
			UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.45) {
				self.safeAreaAnimatedTitleLabelUp()
			}
			UIView.addKeyframe(withRelativeStartTime: 0.50, relativeDuration: 0.45, animations: {
				self.invokeAnimatedTitleLabelUp()
			})
			UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.5, animations: {
				self.containerView.alpha = 1
			})
		})
	}
	
	private func safeAreaAnimatedTitleLabelUp() {
		titleLabelYPosition.update(offset: -(view.safeAreaLayoutGuide.layoutFrame.size.height / 2 - 8))
		view.layoutSubviews()
	}
	
	private func invokeAnimatedTitleLabelUp() {
		titleLabelYPosition.update(offset: -(view.safeAreaLayoutGuide.layoutFrame.size.height / 2 - 16))
		view.layoutSubviews()
	}
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.themeCollectionView {
			return themes.count
		} else {
			return genres.count
		}
	}
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == self.themeCollectionView {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {return UICollectionViewCell()}
			cell.configure(with: themes[indexPath.row].key)
			return cell
		} else {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {return UICollectionViewCell() }
			let genre = genres[indexPath.row]
			cell.configure(model: genre)
			return cell
		}
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: Constants.collectionViewWidth, height: Constants.collectionViewHeight)
	}
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == self.themeCollectionView {
			loadMovies(theme: themes[indexPath.row], genre: genres[indexPath.row])
		} else {
			obtainMovieList(with: genres[indexPath.row].id)
		}
	}
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return movie.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MovieTableViewCell
		let movie = movie[indexPath.row]
		cell.configure(movie)
		let isFavouriteMovie = !self.favouriteMovies.filter({ ($0.value(forKey: "id") as? Int) == movie.id}).isEmpty
		cell.toggleFavouriteImage(with: isFavouriteMovie)
		
		cell.didTapFavorite = { [weak self] in
			guard let self else {return}
			let isFavouriteMovie = !self.favouriteMovies.filter({ ($0.value(forKey: "id") as? Int) == movie.id}).isEmpty
			cell.toggleFavouriteImage(with: !isFavouriteMovie)
			
			if isFavouriteMovie {
				self.deleteFavouriteMovie(with: movie)
			} else {
				self.saveFavouriteMovie(with: movie)
			}
			self.loadFavouriteMovies()
		}
		return cell
	}
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 460
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let movieDetailsController = DetailViewController()
		let movie = movie[indexPath.row]
		movieDetailsController.movieID = movie.id
		self.navigationController?.pushViewController(movieDetailsController, animated: true)
	}
}
