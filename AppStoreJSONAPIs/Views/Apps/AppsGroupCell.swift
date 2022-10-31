//
//  AppsGroupCell.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/22/22.
//

import UIKit

class AppsGroupCell: UICollectionViewCell {
	
	let titleLabel = UILabel(text: "App Section", font: .boldSystemFont(ofSize: 24))
	
	let horizontalController = AppsHorizontalController()
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(titleLabel)
		titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
		
		addSubview(horizontalController.view)
		horizontalController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
