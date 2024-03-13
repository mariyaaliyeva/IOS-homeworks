//
//  LoadingView.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 12.01.2024.
//

import UIKit
import Lottie

class LoadingView: UIView {
	
	private enum Constants {
		static let animationViewSize: CGSize = .init(width: 95, height: 200)
	}
	
	// MARK: - Properties
	var isloading = false
	
	// MARK: - UIView
	private let containerView = UIView()
	
	private let animationView: LottieAnimationView = {
		let view = LottieAnimationView()
		let animation = LottieAnimation.named("loader")
		view.animation = animation
		view.contentMode = .scaleAspectFit
		view.animationSpeed = 1.25
		view.backgroundBehavior = .pauseAndRestore
		return view
	}()
	
	private let backgroundAnimationView: LottieAnimationView = {
		let view = LottieAnimationView()
		let animation = LottieAnimation.named("snow")
		view.animation = animation
		view.contentMode = .scaleAspectFit
		view.animationSpeed = 1.25
		view.backgroundBehavior = .pauseAndRestore
		return view
	}()
	
	// MARK: - Inits
	override init(frame: CGRect) {
		super.init(frame: frame)
		alpha = 0
		setupAnimation()
		hundleNewYearPeriod()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Methods
	func startLoading() {
		if isloading { return }
		
		isloading = true
		
		animationView.play(
			fromProgress: animationView.currentProgress,
			toProgress: 1,
			loopMode: .loop
		)
		backgroundAnimationView.play(
			fromProgress: animationView.currentProgress,
			toProgress: 1,
			loopMode: .loop
		)
		
		UIView.animate(withDuration: 0.25) {
			self.alpha = 1
		}
	}
	
	func stopLoading() {
		isloading = false
		
		UIView.animate(withDuration: 0.25, animations: { [weak self] in
			self?.alpha = 0
		}) { [weak self] _ in
			self?.animationView.stop()
		}
		
		UIView.animate(withDuration: 0.25, animations: { [weak self] in
			self?.alpha = 0
		}) { [weak self] _ in
			self?.backgroundAnimationView.stop()
		}
	}
	
	private func hundleNewYearPeriod() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		dateFormatter.timeZone = TimeZone(identifier: "Asia/Almaty")
		
		let newYearDays = UserDefaults.standard.integer(forKey: "isNewYearPeriod")
		let newYearSettedDay = UserDefaults.standard.string(forKey: "newYearSettedDay")
		let currentDay = dateFormatter.string(from: Date())
		
		if newYearDays <= 2 && currentDay != newYearSettedDay {
			UserDefaults.standard.set(newYearDays + 1, forKey: "isNewYearPeriod")
			UserDefaults.standard.set(currentDay, forKey: "newYearSettedDay")
		}
		
		let finalNewYearDays = UserDefaults.standard.integer(forKey: "isNewYearPeriod")
		
		if finalNewYearDays <= 2 {
			animationView.animation = LottieAnimation.named("cristmas")
			backgroundAnimationView.animation = LottieAnimation.named("snow")
		} else {
			backgroundAnimationView.removeFromSuperview()
		}
	}
	
	// MARK: - Private methods
	private func setupAnimation() {
		addSubview(containerView)
		
		containerView.addSubview(backgroundAnimationView)
		containerView.addSubview(animationView)
		
		containerView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		animationView.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.size.equalTo(Constants.animationViewSize)
		}
		
		backgroundAnimationView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}
