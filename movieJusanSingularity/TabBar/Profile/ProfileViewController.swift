//
//  ProfileViewController.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 27.01.2024.
//

import UIKit
import SwiftKeychainWrapper

final class ProfileViewController: UIViewController {
	
	// MARK: - Props
	
	weak var activeImageView:UIImageView? = nil
	
	// MARK: - UI
	
	private lazy var backImageView: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFill
		image.backgroundColor = .gray
		image.clipsToBounds = true
		return image
	}()
	
	private lazy var photoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.image = UIImage(systemName: "person")
		imageView.tintColor = .black
		imageView.layer.borderWidth = 3
		return imageView
	}()
	
	private var titleInBackImageLabel: UILabel = {
		let label = UILabel()
		label.text = "Profile"
		label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
		return label
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		let backImagetapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelect(_:)))
		backImageView.addGestureRecognizer(backImagetapGesture)
		backImageView.isUserInteractionEnabled = true
		
		let photoImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelect(_:)))
		photoImageView.addGestureRecognizer(photoImageTapGesture)
		photoImageView.isUserInteractionEnabled = true
		loadImage()
		setupViews()
		setupConstraints()
	}
	
	@objc
	func handleSelect(_ sender:  UIGestureRecognizer) {
		guard let sendingImageView = sender.view as? UIImageView else {
			print("Ooops, received this gesture not from an ImageView")
			return
		}
		activeImageView = sendingImageView
		createUIImagePicker()
	}
	
	// MARK: - ViewDidLayoutSubviews
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		backImageView.layer.cornerRadius = 20
		photoImageView.layer.cornerRadius = 50
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	
	// MARK: - Private
	private func createUIImagePicker() {
		let picker = UIImagePickerController()
		picker.sourceType = .photoLibrary
		picker.allowsEditing = true
		picker.delegate = self
		
		let actionsheet = UIAlertController(title: "Photo Source", message: "", preferredStyle: .actionSheet)
		actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction)in
			if UIImagePickerController.isSourceTypeAvailable(.camera){
				picker.sourceType = .camera
				self.present(picker, animated: true, completion: nil)
			} else {
				print("Camera is Not Available")
			}
		}))
		
		actionsheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction)in
			picker.sourceType = .photoLibrary
			self.present(picker, animated: true, completion: nil)
		}))
		actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		self.present(actionsheet,animated: true, completion: nil)
	}
	
	// MARK: - Load Image from UserDefaults
	private func loadImage() {
		
		if let imageURL = UserDefaults.standard.url(forKey: "SelectedImage") {
			if let data = NSData(contentsOf: imageURL) as NSData? {
				self.backImageView.image = UIImage(data: data as Data)
			}
		}
		
		if let imageURL = UserDefaults.standard.url(forKey: "PhotoImage") {
			if let data = NSData(contentsOf: imageURL) as NSData? {
				self.photoImageView.image = UIImage(data: data as Data)
			}
		}
	}
	
	// MARK: - SetupViews
	
	private func setupViews() {
		[backImageView].forEach {
			view.addSubview($0)
		}
		
		[photoImageView, titleInBackImageLabel].forEach {
			backImageView.addSubview($0)
		}
	}
	
	// MARK: - SetupConstraints
	private func setupConstraints() {
		
		backImageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		photoImageView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(150)
			make.centerX.equalToSuperview()
			make.size.equalTo(100)
		}
		
		titleInBackImageLabel.snp.makeConstraints { make in
			make.top.equalTo(photoImageView.snp.bottom).offset(2)
			make.centerX.equalToSuperview()
		}
	}
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			activeImageView?.image = image
			if backImageView.image == activeImageView?.image {
				if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL? {
					UserDefaults.standard.set(imageURL, forKey: "SelectedImage")
					UserDefaults.standard.synchronize()
				}
			}
			
			if photoImageView.image == activeImageView?.image {
				if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL? {
					UserDefaults.standard.set(imageURL, forKey: "PhotoImage")
					UserDefaults.standard.synchronize()
				}
			}
			dismiss(animated: true, completion: nil)
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated:  true, completion: nil)
	}
}

