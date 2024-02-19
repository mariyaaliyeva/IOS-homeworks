//
//  GenreCollectionViewCell.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 19.12.2023.
//

import UIKit
import SnapKit

final class CustomCollectionViewCell: UICollectionViewCell {
	
	static let reuseId = "CustomCollectionViewCell"
	
	override var isSelected: Bool {
		willSet(newValue) {
			if newValue {
				backgroundColor = .red
			} else {
				backgroundColor = #colorLiteral(red: 0.1011425927, green: 0.2329770327, blue: 0.9290834069, alpha: 1)
			}
		}
	}
	// MARK: - UI
	private lazy var customCollectionLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
		layer.cornerRadius = 11
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		isSelected = false
		customCollectionLabel.text = nil
		
	}
	
	//MARK: - Public
	func configure(model: Genre) {
		customCollectionLabel.text = model.name
	}
	
	func configure(with titleForLabel: String) {
		customCollectionLabel.text = titleForLabel
	}
	
	func configureCustomTitle(with font: UIFont) {
		customCollectionLabel.font = font
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		backgroundColor = #colorLiteral(red: 0.1011425927, green: 0.2329770327, blue: 0.9290834069, alpha: 1)
		clipsToBounds = true
		contentView.addSubview(customCollectionLabel)
	}
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		
		customCollectionLabel.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(4)
			make.leading.trailing.equalToSuperview().inset(16)
		}
	}
}
