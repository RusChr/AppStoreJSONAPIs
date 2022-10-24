//
//  AppsPageHeader.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/24/22.
//

import UIKit

class AppsPageHeader: UICollectionReusableView {
	
	let appHeaderHorizontalController = AppsHeaderHorizontalController()
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(appHeaderHorizontalController.view)
		appHeaderHorizontalController.view.fillSuperview()
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
