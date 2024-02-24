//
//  DetailViewController.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 22.12.2023.
//

import UIKit
import SnapKit
import Kingfisher
import Cosmos
import CoreData

final class DetailViewController: BaseViewController {
	
	// MARK: - Properties
	var movieID = Int()
	var movieImage: String?
	var movieName: String?
	var hideDetail: Bool?
	
	// MARK: - Private properties
	private var networkManager = NetworkManager.shared
	private var voteAverage: Int = 0
	private var watchListMovies: [NSManagedObject] = []
	
	private lazy var genres: [Genre] = [] {
		didSet {
			self.genresCollectionView.reloadData()
		}
	}
	
	private lazy var actors: [Actors] = [] {
		didSet {
			self.castCollectionView.reloadData()
		}
	}
	
	// MARK: - UI
	private lazy var scrollView: UIScrollView = {
		let scroll = UIScrollView()
		scroll.backgroundColor = .clear
		scroll.showsHorizontalScrollIndicator = false
		scroll.showsVerticalScrollIndicator = false
		scroll.contentInset = .zero
		return scroll
	}()
	
	private var contentView: UIStackView = {
		let stackView = UIStackView()
		stackView.backgroundColor = .clear
		stackView.axis = .vertical
		stackView.spacing = 20
		stackView.alignment = .center
		return stackView
	}()
	
	private lazy var movieImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private lazy var movieTitleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = .boldSystemFont(ofSize: 24)
		label.textAlignment = .center
		label.textColor = .black
		return label
	}()
	
	private lazy var releaseStack: UIStackView = {
		let stack = UIStackView()
		stack.alignment = .top
		stack.axis = .horizontal
		stack.distribution = .fillEqually
		stack.spacing = 60
		return stack
	}()
	
	private lazy var releaseLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = .systemFont(ofSize: 15)
		label.textAlignment = .left
		label.textColor = .black
		return label
	}()
	
	private lazy var genresCollectionView: UICollectionView = {
		
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.backgroundColor = .clear
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.reuseId)
		return collectionView
	}()
	
	private lazy var raitingStarsView: CosmosView = {
		var view = CosmosView()
		view.settings.filledImage = UIImage(named: "fullstar")?.withRenderingMode(.alwaysOriginal)
		view.settings.emptyImage = UIImage(named: "empty_star")?.withRenderingMode(.alwaysOriginal)
		view.settings.fillMode = .precise
		view.settings.starSize = 20
		view.settings.starMargin = 5
		view.settings.totalStars = 5
		view.settings.updateOnTouch = false
		return view
	}()
	
	private lazy var releaseLabelAndGenreCollectionStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 24
		return stack
	}()
	
	private lazy var raitingStack: UIStackView = {
		let stack = UIStackView()
		stack.distribution = .fillEqually
		stack.axis = .vertical
		return stack
	}()
	
	private lazy var starRaitingStack: UIStackView = {
		let stack = UIStackView()
		stack.alignment = .center
		stack.distribution = .fillEqually
		stack.axis = .vertical
		return stack
	}()
	
	private lazy var raitingLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 15)
		label.textAlignment = .center
		label.textColor = .black
		return label
	}()
	
	private lazy var voteCountLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 10)
		label.textAlignment = .center
		label.textColor = .black
		return label
	}()
	
	private lazy var overviewView: UIView = {
		let view = UIView()
		view.backgroundColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
		return view
	}()
	
	private lazy var titleTextViewLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 30)
		label.textAlignment = .center
		label.textColor = .black
		label.backgroundColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
		label.text = "Overview"
		return label
	}()
	
	private lazy var descriptionTextView: UITextView = {
		let textView = UITextView()
		textView.font = .systemFont(ofSize: 10)
		textView.textColor = .black
		textView.isScrollEnabled = false
		textView.backgroundColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
		textView.textAlignment = .left
		textView.textContainerInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
		textView.sizeToFit()
		return textView
	}()
	
	private lazy var castTitleLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 30)
		label.textAlignment = .center
		label.textColor = .black
		label.text = "Cast"
		return label
	}()
	
	private lazy var castCollectionView: UICollectionView = {
		
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.reuseId)
		return collectionView
	}()
	
	private lazy var linkTitleLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 30)
		label.textAlignment = .center
		label.textColor = .black
		label.text = "Link"
		return label
	}()
	
	private lazy var resourcesStackView: UIStackView = {
		let stack = UIStackView()
		stack.alignment = .center
		stack.axis = .horizontal
		stack.spacing = 30
		return stack
	}()
	
	private lazy var  imdbImageView: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFit
		image.image = UIImage(named: "imdb")
		return image
	}()
	
	private lazy var  youtubeImageView: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFit
		image.image = UIImage(named: "youtube")
		return image
	}()
	
	private lazy var  facebookImageView: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFit
		image.image = UIImage(named: "facebook")
		return image
	}()
	
	private lazy var addToWatchListButton: UIButton = {
		let button = UIButton()
		button.tintColor = .white
		button.titleLabel?.font = .boldSystemFont(ofSize: 10)
		button.addTarget(self, action: #selector(addToWatchList), for: .touchUpInside)
		button.backgroundColor = #colorLiteral(red: 0.1011425927, green: 0.2329770327, blue: 0.9290834069, alpha: 1)
		return button
	}()
	
	private lazy var extraView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		setupNavigationBar()
		setupViews()
		setupConstraints()
		loadMoviesFromWatchList()
		buttonColorViewDidLoad()
		self.tabBarController?.tabBar.isHidden = true
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		addToWatchListButton.layer.cornerRadius = 15
	}

	// MARK: - Navigation bar
	private func setupNavigationBar() {
		self.navigationItem.title = "Movie"
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "chevron.backward"),
			style: .done,
			target: self,
			action: #selector(barButtonTapped))
		navigationController?.navigationBar.tintColor = .black
	}
	
	// MARK: - Action
	
	@objc func barButtonTapped() {
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc func addToWatchList() {
		 toggleButton()
	}
	
	func buttonColorViewDidLoad() {
		let isFavouriteMovie = !self.watchListMovies.filter({ ($0.value(forKey: "id") as? Int) == self.movieID}).isEmpty
		
		if isFavouriteMovie {
			addToWatchListButton.backgroundColor = .red
			addToWatchListButton.setTitle("Remove from Watch List", for: .normal)
		} else {
			addToWatchListButton.backgroundColor = #colorLiteral(red: 0.1011425927, green: 0.2329770327, blue: 0.9290834069, alpha: 1)
			addToWatchListButton.setTitle("Add To Watch List", for: .normal)
		}
	}

	private func toggleButton() {
		
		loadMoviesFromWatchList()
		let isFavouriteMovie = !self.watchListMovies.filter({ ($0.value(forKey: "id") as? Int) == self.movieID}).isEmpty
		
		if !isFavouriteMovie {
			addToWatchListButton.backgroundColor = .red
			addToWatchListButton.setTitle("Remove from Watch List", for: .normal)
			saveMoviesFromWatchList(with: movieImage ?? "", movieTitle: movieName ?? "", movieID: movieID)
		} else {
			addToWatchListButton.backgroundColor = #colorLiteral(red: 0.1011425927, green: 0.2329770327, blue: 0.9290834069, alpha: 1)
			addToWatchListButton.setTitle("Add To Watch List", for: .normal)
			deleteMoviesFromWatchList(with: movieImage ?? "", movieTitle: movieName ?? "", movieID: movieID)
			
			if hideDetail == true {
				self.navigationController?.popViewController(animated: true)
			}
		}

	}
	
	// MARK: - Setup Views
	private func setupViews() {
		view.backgroundColor = .white
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		[movieImageView, movieTitleLabel, releaseStack, overviewView, castTitleLabel, castCollectionView, linkTitleLabel, resourcesStackView, extraView, addToWatchListButton].forEach {
			contentView.addArrangedSubview($0)
		}
		
		[releaseLabel, genresCollectionView].forEach {
			releaseLabelAndGenreCollectionStack.addArrangedSubview($0)
		}
		
		[raitingLabel, voteCountLabel].forEach {
			raitingStack.addArrangedSubview($0)
		}
		
		[raitingStarsView, raitingStack].forEach {
			starRaitingStack.addArrangedSubview($0)
		}
		
		[releaseLabelAndGenreCollectionStack, starRaitingStack].forEach {
			releaseStack.addArrangedSubview($0)
		}
		
		[titleTextViewLabel, descriptionTextView].forEach {
			overviewView.addSubview($0)
		}
		
		[imdbImageView, youtubeImageView, facebookImageView].forEach {
			resourcesStackView.addArrangedSubview($0)
		}
		
		let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
		youtubeImageView.addGestureRecognizer(tapGR)
		youtubeImageView.isUserInteractionEnabled = true
		
		let imdbTapGR = UITapGestureRecognizer(target: self, action: #selector(self.imdbTapped))
		imdbImageView.addGestureRecognizer(imdbTapGR)
		imdbImageView.isUserInteractionEnabled = true
		
		let facebookTapGR = UITapGestureRecognizer(target: self, action: #selector(self.facebookTapped))
		facebookImageView.addGestureRecognizer(facebookTapGR)
		facebookImageView.isUserInteractionEnabled = true
	}
	
	// MARK: - Core
	
	private func loadMoviesFromWatchList() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let manageContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WatchListMovie")
		
		do {
			watchListMovies = try manageContext.fetch(fetchRequest)
//			movieTableView.reloadData()
		} catch let error as NSError {
			print("Could not fetch. Error: \(error)")
		}
	}
	
	private func saveMoviesFromWatchList(with movieImage: String, movieTitle: String, movieID: Int) {
					guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
					let managedContext = appDelegate.persistentContainer.viewContext
					
					guard let entity = NSEntityDescription.entity(
							forEntityName: "WatchListMovie",
							in: managedContext
					) else { return }
					
					let favoriteMove = NSManagedObject(entity: entity, insertInto: managedContext)
					favoriteMove.setValue(movieID, forKey: "id")
					favoriteMove.setValue(movieTitle, forKey: "title")
					favoriteMove.setValue(movieImage, forKey: "posterPath")
					
					do {
							try managedContext.save()
					} catch let error as NSError {
							print("Could not save. Error: \(error)")
					}
			}
	
	private func deleteMoviesFromWatchList(with movieImage: String, movieTitle: String, movieID: Int) {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let manageContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WatchListMovie")
		let predicate1 = NSPredicate(format: "id == %@", "\(movieID)")
		let predicate2 = NSPredicate(format: "title == %@", movieTitle)
		let predicate3 = NSPredicate(format: "posterPath == %@", movieImage)
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
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		
		scrollView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.leading.trailing.bottom.equalToSuperview()
		}
		
		contentView.snp.makeConstraints { make in
			make.top.equalTo(scrollView).offset(12)
			make.bottom.equalTo(scrollView)
			make.width.equalTo(view.frame.width)
		}
		
		movieImageView.snp.makeConstraints { make in
			make.height.equalTo(424)
		}
		
		movieTitleLabel.snp.makeConstraints { make in
			make.leading.equalTo(contentView.snp.leading).offset(32)
			make.trailing.equalTo(contentView.snp.trailing).offset(-32)
		}
		
		releaseLabel.snp.makeConstraints { make in
			make.width.equalTo(100)
		}
		
		releaseStack.snp.makeConstraints { make in
			make.leading.equalTo(contentView.snp.leading).offset(16)
			make.trailing.equalTo(contentView.snp.trailing).offset(-16)
		}
		
		genresCollectionView.snp.makeConstraints { make in
			make.height.equalTo(50)
		}
		
		overviewView.snp.makeConstraints { make in
			make.leading.equalTo(contentView.snp.leading)
			make.trailing.equalTo(contentView.snp.trailing)
			make.height.greaterThanOrEqualTo(100)
		}
		
		titleTextViewLabel.snp.makeConstraints { make in
			make.top.equalTo(overviewView.snp.top).inset(30)
			make.leading.equalTo(overviewView.snp.leading).offset(12)
			make.trailing.equalTo(overviewView.snp.trailing).offset(-12)
		}
		
		descriptionTextView.snp.makeConstraints { make in
			make.top.equalTo(titleTextViewLabel.snp.bottom).offset(30)
			make.leading.equalTo(overviewView.snp.leading)
			make.trailing.equalTo(overviewView.snp.trailing)
			make.bottom.equalTo(overviewView.snp.bottom).offset(-50)
		}
		
		castTitleLabel.snp.makeConstraints { make in
			make.leading.equalTo(contentView.snp.leading).offset(32)
			make.trailing.equalTo(contentView.snp.trailing).offset(-32)
		}
		
		castCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(100)
		}
		
		linkTitleLabel.snp.makeConstraints { make in
			make.leading.equalTo(contentView.snp.leading).offset(32)
			make.trailing.equalTo(contentView.snp.trailing).offset(-32)
		}
		
		resourcesStackView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
		}
		
		extraView.snp.makeConstraints { make in
			make.trailing.leading.equalToSuperview()
			make.height.equalTo(20)
		}
		
		addToWatchListButton.snp.makeConstraints { make in
			make.width.equalTo(147)
			make.height.equalTo(33)
			make.centerX.bottom.equalToSuperview()
		}
	}
	
	// MARK: - Private
	private func loadData() {
		showLoader()
		networkManager.fetchMovieDetails(id: movieID) { [weak self] movieDetails in
			
			let raiting = (movieDetails.voteAverage ?? 0) / 2
			let raitingDouble = Double(String(format: "%.1f", raiting))
			self?.raitingStarsView.rating = raitingDouble ?? 0
			
			guard let posterPath = movieDetails.posterPath else { return }
			
			let urlString = "https://image.tmdb.org/t/p/w200" + (posterPath)
			let url = URL(string: urlString)!
			
			self?.movieImageView.kf.setImage(with: url)
			self?.movieImage = "https://image.tmdb.org/t/p/w200" + (posterPath)
			self?.movieTitleLabel.text = movieDetails.originalTitle
			self?.movieName = movieDetails.originalTitle
			self?.releaseLabel.text = "Release date: \(movieDetails.releaseDate ?? "")"
			self?.genres = movieDetails.genres
			self?.raitingLabel.text = String(format: "%.1f", movieDetails.voteAverage ?? "") + "/10"
			self?.voteCountLabel.text = "\(movieDetails.voteCount ?? 0)K"
			self?.descriptionTextView.text = movieDetails.overview
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
				self?.hideLoader()
			}
		}
		
		networkManager.fetchCast(id: movieID) { [weak self] castDetails in
			self?.actors = castDetails
		}
	}
	
	@objc
	func imageTapped() {
		//    https://www.youtube.com/watch?v=
		//    https://api.themoviedb.org/3/movie/466420/videos?api_key=e516e695b99f3043f08979ed2241b3db
		
		networkManager.fetchVideos(id: movieID) { videos in
			print(self.movieID)
			let youtubeVideos = videos.filter { video in
				if let site = video.site {
					site.contains("YouTube")
				} else {
					.init()
				}
			}
			guard let key = youtubeVideos.first?.key else {
				return
			}
			
			let urlString = "https://www.youtube.com/watch?v=" + key
			if let url = URL(string: urlString) {
				UIApplication.shared.open(url)
			}
		}
	}
	
	@objc
	func imdbTapped() {
		
		networkManager.fetchImdb(id: movieID) { videos in
			
			let urlString = "https://www.imdb.com/title/" + "\(videos.imdbID)"
			if let url = URL(string: urlString) {
				UIApplication.shared.open(url)
			}
		}
	}
	
	@objc
	func facebookTapped() {
		
		networkManager.fetchImdb(id: movieID) { videos in
			
			let urlString = "https://www.facebook.com/" + "\(String(describing: videos.facebookID))"
			if let url = URL(string: urlString) {
				UIApplication.shared.open(url)
			}
		}
	}
}

// MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.genresCollectionView {
			return genres.count
		} else {
			if collectionView == self.castCollectionView {
				return actors.count
			}
			return 1
		}
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == self.genresCollectionView {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {return UICollectionViewCell() }
			let genre = genres[indexPath.row]
			cell.configure(model: genre)
			cell.configureCustomTitle(with: UIFont.systemFont(ofSize: 10))
			cell.isUserInteractionEnabled = false
			return cell
		} else {
			if collectionView == self.castCollectionView {
				guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as? CastCollectionViewCell else {return UICollectionViewCell() }
				cell.configure(model: actors[indexPath.row])
				return cell
			}
			return UICollectionViewCell()
		}
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 150, height: 35)
	}
}

// MARK: - UICollectionViewDelegate
extension DetailViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == self.castCollectionView {
			let actorsDetailsController = ActorsViewController()
			let actors = actors[indexPath.row]
			actorsDetailsController.personID = actors.id
			self.navigationController?.pushViewController(actorsDetailsController, animated: true)
		}
	}
}
