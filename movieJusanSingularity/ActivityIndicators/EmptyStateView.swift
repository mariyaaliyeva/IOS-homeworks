//
//  EmptyStateView.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 19.02.2024.
//

import Foundation
import UIKit

class EmptyStateView: UIView {
	
	// MARK: - Constants
	
	private enum Constants {
		static let imageViewSize: CGSize = .init(width: 200, height: 135)
	}
	
	// MARK: - Properties

	// MARK: - UIView
	
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .fillProportionally
		stackView.spacing = 16
		return stackView
	}()
	
	private lazy var imageView: UIImageView = {
		let image = UIImageView()
		image.image = UIImage(named: "network_error")
		image.contentMode = .scaleAspectFill
		return image
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Something went wrong"
		label.font = UIFont.boldSystemFont(ofSize: 20)
		label.textAlignment = .center
		return label
	}()
	
	private lazy var subTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "Try to reload page."
		label.font = UIFont.systemFont(ofSize: 16)
		label.textAlignment = .center
		return label
	}()
	
	// MARK: - Init
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Public
	
	func configure(image: UIImage, title: String, subtitle: String) {
		imageView.image = image
		titleLabel.text = title
		subTitleLabel.text = subtitle
	}
	
	// MARK: - Private
	
	private func setupViews() {
		addSubview(stackView)
		backgroundColor = .clear
		
		[imageView, titleLabel, subTitleLabel].forEach {
			stackView.addArrangedSubview($0)
		}
		
		stackView.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
		
		imageView.snp.makeConstraints { make in
			make.height.equalTo(Constants.imageViewSize)
		}
		
	}
}
