//
//  Extension.swift
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
		self.textColor = .black
	}
}


extension UIImageView {
	convenience init(cornerRadius: CGFloat) {
		self.init(image: nil)
		self.layer.cornerRadius = cornerRadius
		self.clipsToBounds = true
		self.contentMode = .scaleAspectFill
	}
}


extension UIButton {
	convenience init(title: String) {
		self.init(type: .system)
		self.setTitle(title, for: .normal)
	}
}
