//
//  GaleryViewController.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 11.01.2024.
//

import UIKit

final class GaleryViewController: UIViewController {
	
	// MARK: - Props
	var photoes: [Profile] = []
	var photoIndexPath = Int()
	var photoIndex = IndexPath()
	
	// MARK: - UI
	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .black
		collectionView.isPagingEnabled = true
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(GaleryCollectionViewCell.self, forCellWithReuseIdentifier: "GaleryCollectionViewCell")
		return collectionView
	}()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationController()
		setupViews()
		setupConstraints()
	}
	
	// MARK: - setupNavigationController
	private func setupNavigationController() {
		self.title = "\(photoIndexPath + 1)/\(photoes.count)"
		let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		self.navigationController?.navigationBar.titleTextAttributes = textAttributes
		self.navigationController?.navigationBar.tintColor = .white
		self.navigationItem.hidesBackButton = true
		let xMarkButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(exitButtonTapped))
		self.navigationItem.rightBarButtonItem = xMarkButton
	}
	
	@objc
	private func exitButtonTapped() {
		self.navigationController?.popViewController(animated: true)
	}
	
	// MARK: - ViewDidLayoutSubviews
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		collectionView.scrollToItem(at: IndexPath(item: photoIndexPath, section: 0), at: .centeredHorizontally, animated: false)
	}
	
	// MARK: - SetupViews
	private func setupViews() {
		view.backgroundColor = .black
		view.addSubview(collectionView)
	}
	// MARK: - SetupConstraints
	private func setupConstraints() {
		collectionView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate
extension GaleryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photoes.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: "GaleryCollectionViewCell",
			for: indexPath
		) as! GaleryCollectionViewCell
		cell.configure(model: photoes[indexPath.row])
		return cell
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
	}
	
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		let y = targetContentOffset.pointee.y
		_ = Int(y / view.frame.height)
	}

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		if let collectionView = scrollView as? UICollectionView {
			let visibleIndexPaths = collectionView.indexPathsForVisibleItems
			if let lastIndexPath = visibleIndexPaths.last {
				self.title = "\(lastIndexPath.row + 1)/\(photoes.count)"
			}
		}
	}
}
