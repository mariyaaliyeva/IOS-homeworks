//
//  PhotoCollectionViewCell.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 28.12.2023.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
	
	static let reuseId = "PhotoCollectionViewCell"
	
	// MARK: - UI
	private lazy var countLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .boldSystemFont(ofSize: 12)
		return label
		
	}()
	private lazy var photoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.backgroundColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
		return imageView
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
	func configure(model: Profile) {
		let urlString = "https://image.tmdb.org/t/p/w200" + (
			model.filePath)
		let url = URL(string: urlString)!
		photoImageView.kf.setImage(with: url)
	}
	
	func configure(count: String) {
		countLabel.text = count
	}
	
	func configure(alpha: Double) {
		photoImageView.alpha = alpha
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		backgroundColor = .clear
		contentView.addSubview(photoImageView)
		photoImageView.addSubview(countLabel)
	}
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		
		photoImageView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().offset(2)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(107)
			make.width.equalTo(63)
		}
		countLabel.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
		}
	}
}
