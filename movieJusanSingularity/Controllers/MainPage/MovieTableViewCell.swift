//
//  MovieTableViewCell.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 19.12.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieTableViewCell: UITableViewCell {
	
	var didTapFavorite: (() -> Void)?
	
	static var reuseId = String(describing: MovieTableViewCell.self)
	
	// MARK: - UI
	private var favoriteIconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.image = UIImage(named: "empty_star")
		imageView.isUserInteractionEnabled = true
		return imageView
	}()
	
	private lazy var movieImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleToFill
		imageView.clipsToBounds = true
		imageView.isUserInteractionEnabled = true
		return imageView
	}()
	
	private lazy var movieTitleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = .boldSystemFont(ofSize: 20)
		label.textAlignment = .center
		label.textColor = .black
		return label
	}()
	
	// MARK: - Lifecycle
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		movieImageView.layer.cornerRadius = 15
	}
	
	//MARK: - Public
	func configure(_ model: MovieResult) {
		movieTitleLabel.text = model.title
		let urlString = "https://image.tmdb.org/t/p/w200" + (
			model.posterPath)
		let url = URL(string: urlString)!
		movieImageView.kf.setImage(with: url)
	}
	
	func configureForSearch(_ model: SearchResult) {
		movieTitleLabel.text = model.title
		let urlString = "https://image.tmdb.org/t/p/w200" + (
			model.posterPath)
		let url = URL(string: urlString)!
		movieImageView.kf.setImage(with: url)
	}
	
	func configureForRecomended(_ model: RecommendedMovie) {
		movieTitleLabel.text = model.title
		let urlString = "https://image.tmdb.org/t/p/w200" + (
			model.posterPath)
		let url = URL(string: urlString)!
		movieImageView.kf.setImage(with: url)
	}
	
	func configureFavouriteMovie(with title: String, and imagePath: String) {
		movieTitleLabel.text = title
		
		let urlString = "https://image.tmdb.org/t/p/w200" + (imagePath)
		let url = URL(string: urlString)!
		movieImageView.kf.setImage(with: url)
	}
	
	func configureStar() {
		favoriteIconImageView.isHidden = true
	}
	
	func toggleFavouriteImage(with isFavourite: Bool) {
		favoriteIconImageView.image = isFavourite ? UIImage(named: "fullstar") : UIImage(named: "empty_star")
	}

	// MARK: - Setup Views
	private func setupViews() {
		contentView.backgroundColor = .clear
		contentView.isUserInteractionEnabled = true
		selectionStyle = .none
		[movieImageView, movieTitleLabel].forEach {
			contentView.addSubview($0)
		}
		movieImageView.addSubview(favoriteIconImageView)
	}
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		
		movieImageView.snp.makeConstraints { make in
			make.top.equalTo(contentView)
			make.leading.equalTo(contentView).offset(32)
			make.trailing.equalTo(contentView).offset(-32)
			make.height.equalTo(400)
		}
		
		favoriteIconImageView.snp.makeConstraints { make in
			make.top.equalTo(movieImageView.snp.top).offset(16)
			make.trailing.equalTo(movieImageView.snp.trailing).offset(-16)
			make.size.equalTo(36)
		}
		
		movieTitleLabel.snp.makeConstraints { make in
			make.top.equalTo(movieImageView.snp.bottom).offset(16)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-16)
		}
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(didTapFavoriteImage))
		favoriteIconImageView.addGestureRecognizer(tap)
	}
	
	@objc
	private func didTapFavoriteImage() {
		didTapFavorite?()
	}
}
