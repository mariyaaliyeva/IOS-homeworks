//
//  MoviewActorsCollectionViewCell.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 28.12.2023.
//

import UIKit

final class MoviewActorsCollectionViewCell: UICollectionViewCell {
	
	static let reuseId = "MoviewActorsCollectionViewCell"
	
	// MARK: - UI
	private lazy var photoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.backgroundColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
		return imageView
	}()
	
	private lazy var namesStack: UIStackView = {
		let stack = UIStackView()
		stack.distribution = .fillEqually
		stack.axis = .vertical
		stack.alignment = .center
		return stack
	}()
	
	private lazy var movieNameLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = .black
		label.font = .boldSystemFont(ofSize: 10)
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.sizeToFit()
		return label
	}()
	
	private lazy var yearLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = .gray
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 8, weight: .regular)
		return label
	}()
	
	// MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupViews()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		photoImageView.layer.cornerRadius = 15
	}
	
	//MARK: - Public
	func configure(model: Cast) {
		
		let urlString = "https://image.tmdb.org/t/p/w200" + (
			model.posterPath ?? "")
		let url = URL(string: urlString)!
		photoImageView.kf.setImage(with: url)
		movieNameLabel.text = model.title
		yearLabel.text = model.releaseDate
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		backgroundColor = .clear
		contentView.addSubview(photoImageView)
		contentView.addSubview(namesStack)
		namesStack.addArrangedSubview(movieNameLabel)
		namesStack.addArrangedSubview(yearLabel)
	}
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		
		photoImageView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(4)
			make.leading.equalToSuperview().inset(16)
			make.height.equalTo(72)
			make.width.equalTo(57)
		}
		
		namesStack.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(4)
			make.leading.equalTo(photoImageView.snp.trailing).offset(16)
			make.trailing.equalToSuperview()
			make.width.equalTo(70)
		}
	}
}
