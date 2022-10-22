//
//  UILabel+Extension.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/22/22.
//

import UIKit

extension UILabel {
	convenience init(text: String, font: UIFont) {
		self.init(frame: .zero)
		self.text = text
		self.font = font
	}
}
