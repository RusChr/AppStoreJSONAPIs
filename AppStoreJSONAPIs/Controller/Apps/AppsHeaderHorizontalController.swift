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
	
	
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//		return .init(top: 0, left: leftRightPadding, bottom: 0, right: leftRightPadding)
//	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return socialApps.count
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsHeaderCell
		let socialApp = socialApps[indexPath.item]
		
		cell.companyLabel.text = socialApp.name
		cell.titleLabel.text = socialApp.tagline
		cell.imageView.sd_setImage(with: URL(string: socialApp.imageUrl))
		
		return cell
	}
}
