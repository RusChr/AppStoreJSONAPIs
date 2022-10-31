//
//  AppsHorizontalController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/22/22.
//

import UIKit

class AppsHorizontalController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	fileprivate let cellId = "cellId"
	
	let topBottomPadding: CGFloat = 12
	let leftRightPadding: CGFloat = 16
	let lineSpacing: CGFloat = 10
	
	var appGroup: AppGroup?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: cellId)
		
		if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
			layout.scrollDirection = .horizontal
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
		return .init(top: topBottomPadding, left: leftRightPadding, bottom: topBottomPadding, right: leftRightPadding)
	}
}
