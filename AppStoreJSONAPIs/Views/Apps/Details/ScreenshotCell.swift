//
//  ScreenshotCell.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/3/22.
//

import UIKit

class ScreenshotCell: UICollectionViewCell {
	
	let imageView = UIImageView(cornerRadius: 12)
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		imageView.backgroundColor = .purple
		imageView.layer.borderWidth = 0.5
		imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
		
		addSubview(imageView)
		imageView.fillSuperview()
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
