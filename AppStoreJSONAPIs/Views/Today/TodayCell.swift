//
//  TodayCell.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/7/22.
//

import UIKit

class TodayCell: UICollectionViewCell {
	
	let imageView = UIImageView(image: #imageLiteral(resourceName: "garden"))
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .white
		layer.cornerRadius = 16
		
		addSubview(imageView)
		imageView.centerInSuperview(size: .init(width: 250, height: 250))
		imageView.contentMode = .scaleAspectFill
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
