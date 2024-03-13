//
//  GaleryCollectionViewCell.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 11.01.2024.
//

import UIKit

final class GaleryCollectionViewCell: UICollectionViewCell {
	
	// MARK: - UI
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
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
	
	// MARK: - Public methods
	func configure(model: Profile) {
		let urlString = "https://image.tmdb.org/t/p/w200" + (
			model.filePath)
		let url = URL(string: urlString)!
		imageView.kf.setImage(with: url)
	}
	
	// MARK: - SetupViews
	private func setupViews() {
		backgroundColor = .clear
		contentView.addSubview(imageView)
	}
	
	// MARK: - SetupConstraints
	private func setupConstraints() {
		imageView.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.leading.trailing.equalToSuperview().inset(20)
			make.top.bottom.equalToSuperview()
		}
	}
}
