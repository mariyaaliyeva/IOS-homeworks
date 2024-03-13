//
//  Data+PrettyJson.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 20.12.2023.
//

import Foundation

extension Data {
	
	var prettyJSON: NSString? { /// NSString give us a nice sanitized debugDescription
		guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
					let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
					let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
		
		return prettyPrintedString
	}
}
