//
//  AppsHeaderHorizontalController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/24/22.
//

import UIKit

class AppsHeaderHorizontalController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout {
	
	fileprivate let cellId = "cellId"
	
	var socialApps = [SocialApp]()
	
	let leftRightPadding: CGFloat = 16
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: cellId)
		
		collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width - (leftRightPadding * 3), height: view.frame.height)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return socialApps.count
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsHeaderCell
		let app = socialApps[indexPath.item]
		
		cell.companyLabel.text = app.name
		cell.titleLabel.text = app.tagline
		cell.imageView.sd_setImage(with: URL(string: app.imageUrl))
		
		return cell
	}
}
