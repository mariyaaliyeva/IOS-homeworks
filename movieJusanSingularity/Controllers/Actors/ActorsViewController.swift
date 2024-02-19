//
//  ActorsViewController.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 27.12.2023.
//

import UIKit

final class ActorsViewController: BaseViewController {
	
	// MARK: - Properties
	var personID = Int()
	
	// MARK: - Private properties
	private var networkManager = NetworkManager.shared
	
	private lazy var images: [Profile] = [] {
		didSet {
			self.photoCollectionView.reloadData()
		}
	}
	
	private lazy var movieActors: [Cast] = [] {
		didSet {
			self.movieCollectionView.reloadData()
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
	
	private lazy var actorImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private lazy var actorNameLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = .boldSystemFont(ofSize: 24)
		label.textAlignment = .center
		label.textColor = .black
		return label
	}()
	
	private lazy var yearStack: UIStackView = {
		let stack = UIStackView()
		stack.distribution = .fillEqually
		stack.axis = .vertical
		return stack
	}()
	
	private lazy var birdhdayLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = .boldSystemFont(ofSize: 14)
		label.textAlignment = .center
		label.textColor = .black
		return label
	}()
	
	private lazy var placeLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = .boldSystemFont(ofSize: 14)
		label.textAlignment = .center
		label.textColor = .black
		return label
	}()
	
	private lazy var deathLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = .boldSystemFont(ofSize: 14)
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
		label.text = "Bio"
		return label
	}()
	
	private lazy var descriptionTextView: UITextView = {
		let textView = UITextView()
		textView.font = .systemFont(ofSize: 10)
		textView.textColor = .black
		textView.isScrollEnabled = false
		textView.backgroundColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
		textView.textAlignment = .left
		textView.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
		textView.sizeToFit()
		return textView
	}()
	
	private lazy var photoTitleLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 30)
		label.textAlignment = .center
		label.textColor = .black
		label.text = "Photo"
		return label
	}()
	
	private lazy var movieTitleLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 30)
		label.textAlignment = .center
		label.textColor = .black
		label.text = "Movie"
		return label
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
		stack.distribution = .fillEqually
		stack.axis = .horizontal
		stack.spacing = 20
		return stack
	}()
	
	private lazy var  imdbImageView: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFit
		image.image = UIImage(named: "imdb")
		return image
	}()
	
	private lazy var  instagramImageView: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFit
		image.image = UIImage(named: "instagram")
		return image
	}()
	
	private lazy var photoCollectionView: UICollectionView = {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseId)
		return collectionView
	}()
	
	private lazy var movieCollectionView: UICollectionView = {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.dataSource = self
		collectionView.register(MoviewActorsCollectionViewCell.self, forCellWithReuseIdentifier: MoviewActorsCollectionViewCell.reuseId)
		return collectionView
	}()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		setupNavigationBar()
		setupViews()
		setupConstraints()
	}
	
	// MARK: - Navigation bar
	private func setupNavigationBar() {
		self.navigationItem.title = "Actor"
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "chevron.backward"),
			style: .done,
			target: self,
			action: #selector(barButtonTapped))
		navigationController?.navigationBar.tintColor = .black
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.title = "Actor"
		
		navigationController?.navigationBar.titleTextAttributes = [
			.foregroundColor: UIColor.black
		]
		navigationController?.navigationBar.tintColor = .black
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		view.backgroundColor = .white
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		[actorImageView, actorNameLabel, yearStack, overviewView, photoTitleLabel, photoCollectionView, movieTitleLabel, movieCollectionView, linkTitleLabel, resourcesStackView].forEach {
			contentView.addArrangedSubview($0)
		}
		
		[birdhdayLabel, placeLabel, deathLabel].forEach {
			yearStack.addArrangedSubview($0)
		}
		
		[titleTextViewLabel, descriptionTextView].forEach {
			overviewView.addSubview($0)
		}
		
		[imdbImageView, instagramImageView].forEach {
			resourcesStackView.addArrangedSubview($0)
		}
		
		let imdbTapGR = UITapGestureRecognizer(target: self, action: #selector(self.imdbTapped))
		imdbImageView.addGestureRecognizer(imdbTapGR)
		imdbImageView.isUserInteractionEnabled = true
		
		let instagramTapGR = UITapGestureRecognizer(target: self, action: #selector(self.instagramTapped))
		instagramImageView.addGestureRecognizer(instagramTapGR)
		instagramImageView.isUserInteractionEnabled = true
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
		
		actorImageView.snp.makeConstraints { make in
			make.height.equalTo(424)
		}
		
		actorNameLabel.snp.makeConstraints { make in
			make.leading.equalTo(contentView.snp.leading).offset(32)
			make.trailing.equalTo(contentView.snp.trailing).offset(-32)
		}
		
		yearStack.snp.makeConstraints { make in
			make.leading.equalTo(contentView.snp.leading).offset(32)
			make.trailing.equalTo(contentView.snp.trailing).offset(-32)
		}
		
		overviewView.snp.makeConstraints { make in
			make.leading.trailing.equalTo(contentView)
			make.height.greaterThanOrEqualTo(100)
		}
		
		titleTextViewLabel.snp.makeConstraints { make in
			make.top.equalTo(overviewView.snp.top).inset(30)
			make.leading.equalTo(overviewView.snp.leading).offset(12)
			make.trailing.equalTo(overviewView.snp.trailing).offset(-12)
		}
		
		descriptionTextView.snp.makeConstraints { make in
			make.top.equalTo(titleTextViewLabel.snp.bottom).offset(30)
			make.leading.trailing.equalTo(overviewView)
			make.bottom.equalTo(overviewView.snp.bottom).offset(-50)
		}
		
		photoTitleLabel.snp.makeConstraints { make in
			make.leading.equalTo(contentView.snp.leading).offset(32)
			make.trailing.equalTo(contentView.snp.trailing).offset(-32)
		}
		
		photoCollectionView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(34)
			make.trailing.equalToSuperview().offset(-34)
			make.height.equalTo(120)
		}
		
		movieTitleLabel.snp.makeConstraints { make in
			make.leading.equalTo(contentView.snp.leading).offset(32)
			make.trailing.equalTo(contentView.snp.trailing).offset(-32)
		}
		
		movieCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(120)
		}
		
		linkTitleLabel.snp.makeConstraints { make in
			make.leading.equalTo(contentView.snp.leading).offset(32)
			make.trailing.equalTo(contentView.snp.trailing).offset(-32)
		}
		
		resourcesStackView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}
	
	// MARK: - Private
	private func loadData() {
		
		let group = DispatchGroup()
		let queue = DispatchQueue.global()
		
		group.enter()
		showLoader()
		queue.async {
			self.networkManager.fetchBioActors(id: self.personID) { [weak self] bioDetails in
				
				self?.actorNameLabel.text =  bioDetails.name
				let urlString = "https://image.tmdb.org/t/p/w200" + (
					bioDetails.profilePath)
				let url = URL(string: urlString)!
				self?.actorImageView.kf.setImage(with: url)
				self?.descriptionTextView.text = bioDetails.biography
				self?.birdhdayLabel.text = "Born: \(bioDetails.birthday)"
				self?.placeLabel.text = bioDetails.placeOfBirth
				if bioDetails.deathday != nil {
					self?.deathLabel.text = "Death: \(bioDetails.deathday ?? "")"
				}
			}
			group.leave()
		}
		
		group.enter()
		queue.async {
			self.networkManager.fetchImagesActors(id: self.personID) { [weak self] imageDetails in
				self?.images = imageDetails
			}
			group.leave()
		}
		
		group.enter()
		queue.async {
			self.networkManager.fetchMovieActors(id: self.personID) { [weak self] movieDetails in
				self?.movieActors = movieDetails
			}
			group.leave()
		}
		
		group.notify(queue: .main) {
			DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
				self.hideLoader()
			}
		}
	}
	
	@objc func barButtonTapped() {
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc
	func imdbTapped() {
		
		networkManager.fetchSocialMediaActors(id: personID) { socialMediaActors in
			
			let urlString = "https://www.imdb.com/name/" + "\(socialMediaActors.imdbID)"
			if let url = URL(string: urlString) {
				UIApplication.shared.open(url)
			}
		}
	}
	
	@objc
	func instagramTapped() {
		
		networkManager.fetchSocialMediaActors(id: personID) { socialMediaActors in
			
			let urlString = "https://www.instagram.com/" + "\(socialMediaActors.instagramID)"
			if let url = URL(string: urlString) {
				UIApplication.shared.open(url)
			}
		}
	}
}

// MARK: - UICollectionViewDataSource
extension ActorsViewController: UICollectionViewDataSource {
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.photoCollectionView {
			if images.count <= 4 {
				return images.count
			} else {
				return 4
			}
			
		} else {
			if collectionView == self.movieCollectionView {
				return movieActors.count
			}
			return images.count
		}
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if collectionView == self.photoCollectionView {
			
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell() }
			if indexPath.row == 3 {
				cell.configure(model: images[indexPath.row])
				cell.configure(count: "+\(images.count - 3)")
				cell.configure(alpha: 0.5)
				return cell
			} else {
				cell.configure(model: images[indexPath.row])
			}
			
			return cell
		} else {
			if collectionView == self.movieCollectionView {
				guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviewActorsCollectionViewCell", for: indexPath) as? MoviewActorsCollectionViewCell else {return UICollectionViewCell() }
				cell.configure(model: movieActors[indexPath.row])
				return cell
			}
			return UICollectionViewCell()
		}
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ActorsViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 150, height: 150)
	}
}

extension ActorsViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let galeryDetailsController = GaleryViewController()
		galeryDetailsController.photoes = images
		galeryDetailsController.photoIndexPath = indexPath.row
		galeryDetailsController.photoIndex = indexPath
		self.navigationController?.pushViewController(galeryDetailsController, animated: true)
	}
}

