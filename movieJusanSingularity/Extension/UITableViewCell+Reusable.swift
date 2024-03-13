//
//  UITableViewCell+Reusable.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 19.12.2023.
//

import Foundation
import UIKit

protocol Reusable {}

extension UITableViewCell: Reusable {}

extension Reusable where Self: UITableViewCell {
	
	static var reuseID: String {
		return String(describing: self)
	}
}
