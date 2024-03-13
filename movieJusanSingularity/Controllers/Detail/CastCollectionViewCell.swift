//
//  CastCollectionViewCell.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 26.12.2023.
//

import UIKit

final class CastCollectionViewCell: UICollectionViewCell {
	
	static let reuseId = "CastCollectionViewCell"
	
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
		return stack
	}()
	
	private lazy var actorNameLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = .black
		label.font = .boldSystemFont(ofSize: 12)
		return label
	}()
	
	private lazy var heroNameLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = .gray
		label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
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
		photoImageView.layer.cornerRadius = 40
	}
	
	//MARK: - Public
	func configure(model: Actors) {
		let urlString = "https://image.tmdb.org/t/p/w200" + (
			model.profilePath ?? "")
		let url = URL(string: urlString)!
		photoImageView.kf.setImage(with: url)
		actorNameLabel.text = model.name
		heroNameLabel.text = model.character
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		backgroundColor = .clear
		[photoImageView, namesStack].forEach {
			contentView.addSubview($0)
		}
		[actorNameLabel, heroNameLabel].forEach {
			namesStack.addArrangedSubview($0)
		}
	}
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		
		photoImageView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(4)
			make.leading.equalToSuperview().inset(16)
			make.size.equalTo(80)
		}
		
		namesStack.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(24)
			make.leading.equalTo(photoImageView.snp.trailing).offset(16)
			make.trailing.equalToSuperview().inset(16)
		}
	}
}
