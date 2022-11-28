//
//  AppsHorizontalController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/22/22.
//

import UIKit

class AppsHorizontalController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout {
	
	fileprivate let cellId = "cellId"
	
	let topBottomPadding: CGFloat = 12
	let leftRightPadding: CGFloat = 16
	let lineSpacing: CGFloat = 10
	
	var appGroup: AppGroup?
	var didSelectHandler: ((FeedResult) -> Void)?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: cellId)
		
		collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let app = appGroup?.feed.results[indexPath.item] {
			didSelectHandler?(app)
		}
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return appGroup?.feed.results.count ?? 0
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppRowCell
		let app = appGroup?.feed.results[indexPath.item]
		
		cell.nameLabel.text = app?.name
		cell.companyLabel.text = app?.artistName
		cell.appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
		
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let height = (view.frame.height - (topBottomPadding * 2) - (lineSpacing * 2)) / 3
		let width = view.frame.width - (leftRightPadding * 3)
		return .init(width: width, height: height)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return lineSpacing
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: topBottomPadding, left: 0, bottom: topBottomPadding, right: 0)
	}
}
