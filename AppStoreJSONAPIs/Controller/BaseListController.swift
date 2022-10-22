//
//  BaseListController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/22/22.
//

import UIKit

class BaseListController: UICollectionViewController {
	
	init() {
		super.init(collectionViewLayout: UICollectionViewFlowLayout())
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
