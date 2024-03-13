//
//  ProfileViewController.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 13.01.2024.
//

import UIKit
import SwiftKeychainWrapper

final class LoginViewController: UIViewController {
	
	var networkManager = NetworkManager.shared

	// MARK: - Props
 var isLogin = false
	private var loginText: String?
	private var passwordText: String?
	
	// MARK: - UI
	
	private var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Enter your details"
		label.font = .systemFont(ofSize: 15)
		return label
	}()
	
	private lazy var loginTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter login"
		textField.borderStyle = .roundedRect
		textField.delegate = self
		return textField
	}()
	
	private lazy var passwordTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter password"
		textField.borderStyle = .roundedRect
		textField.isSecureTextEntry = true
		textField.enablePasswordToggle()
		textField.delegate = self
		return textField
	}()
	
	private var errorLabel: UILabel = {
		let label = UILabel()
		label.text = "Логин или пароль введен неверно"
		label.font = .systemFont(ofSize: 12)
		label.textColor = .red
		label.isHidden = true
		return label
	}()
	
	private lazy var loginButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Login in", for: .normal)
		button.backgroundColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
		button.tintColor = .black
		button.clipsToBounds = true
		button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
		return button
	}()

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupNavigationBar()
		setupViews()
		setupConstraints()
	}
	
	// MARK: - Navigation bar
	private func setupNavigationBar() {
		self.navigationItem.title = "Log In"
	}
	
	// MARK: - ViewDidLayoutSubviews
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		loginButton.layer.cornerRadius = 10
	}
	
	@objc func didTapLogin() {
		loginText = loginTextField.text
		passwordText = passwordTextField.text
		
		guard let loginText, let passwordText else { return }
		
		networkManager.getRequestToken { [weak self] result in
			switch result {
			case .success(let dataModel):
				if dataModel.success {
					let requestData: ValidateAuthenticationModel = .init(
						username: loginText,
						password: passwordText,
						requestToken: dataModel.requestToken
					)
					self?.validateWithLogin(with: requestData)
				}
			case .failure:
				break
			}
		}
	}

	// MARK: - Private
	private func validateWithLogin(with data: ValidateAuthenticationModel) {
		networkManager.validateWithLogin(
			requestBody: data.toDictionary(),
			completion: { [weak self] result in
				switch result {
				case .success(let dataModel):
					if dataModel.success {
						let requestData = ["request_token": dataModel.requestToken]
						self?.createSession(with: requestData)
						let profileController = ProfileViewController()
						self?.navigationController?.pushViewController(profileController, animated: true)
					}
				case .failure:
					self?.errorLabel.isHidden = false
					self?.loginTextField.resignFirstResponder()
					self?.passwordTextField.resignFirstResponder()
					break
				}
			}
		)
	}
	
	private func createSession(with requestBody: [String: Any]) {
		networkManager.createSession(requestBody: requestBody) { result in
			switch result {
			case .success(let sessionId):
				print("My sessionId is \(sessionId)")
				KeychainWrapper.standard.set(sessionId, forKey: "apiKey")
				self.isLogin = true
				UserDefaults.standard.setValue(self.isLogin, forKey: "isLogin")
			case .failure:
				self.showAlert()
				break
			}
		}
	}
	
	private func showAlert() {
		let alert = UIAlertController(title: "Произошла ошибка!", message: "Попробуйте позднее", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
		}
		alert.addAction(okAction)
		present(alert, animated: true, completion: nil)
	}
	
	// MARK: - SetupViews
	
	private func setupViews() {
		[titleLabel, loginTextField, passwordTextField, errorLabel, loginButton].forEach {
			view.addSubview($0)
		}
	}
	
	// MARK: - SetupConstraints
	
	private func setupConstraints() {
		
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(150)
			make.leading.trailing.equalToSuperview().inset(16)
		}
		
		loginTextField.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(28)
			make.leading.trailing.equalTo(titleLabel)
			make.height.equalTo(35)
		}
		
		passwordTextField.snp.makeConstraints { make in
			make.top.equalTo(loginTextField.snp.bottom).offset(16)
			make.leading.trailing.equalTo(loginTextField)
			make.height.equalTo(35)
		}
		
		errorLabel.snp.makeConstraints { make in
			make.top.equalTo(passwordTextField.snp.bottom).offset(8)
			make.leading.equalTo(view.snp.leading).offset(28)
			make.trailing.equalTo(view.snp.trailing).offset(-16)
		}
		
		loginButton.snp.makeConstraints { make in
			make.top.equalTo(passwordTextField.snp.bottom).offset(200)
			make.centerX.equalToSuperview()
			make.height.equalTo(40)
			make.width.equalTo(120)
		}
	}
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		self.errorLabel.isHidden = true
		return true
	}
}
