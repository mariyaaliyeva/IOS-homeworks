//
//  TextField+SecuryText.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 30.01.2024.
//

import Foundation
import UIKit

extension UITextField {
	
	func setPasswordToggleImage(_ button: UIButton) {
		if(isSecureTextEntry){
			button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
		}else{
			button.setImage(UIImage(systemName: "eye"), for: .normal)
			
		}
	}
	
	func enablePasswordToggle() {
		let button = UIButton(type: .custom)
		button.tintColor = .black
		button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
		setPasswordToggleImage(button)
		
		let configuration = UIButton.Configuration.plain()
		button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 8)
		button.configuration = configuration
		button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
		self.rightView = button
		self.rightViewMode = .always
	}
	
	@objc func togglePasswordView(_ sender: Any) {
		self.isSecureTextEntry = !self.isSecureTextEntry
		setPasswordToggleImage(sender as! UIButton)
	}
}
