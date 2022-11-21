//
//  PodcastsController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 21.11.2022.
//

import UIKit

class PodcastController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	fileprivate let cellId = "cellId"
	fileprivate let footerId = "footerId"
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.register(TrackCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(PodcastLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 20
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrackCell
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width, height: 100)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
		return footer
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return .init(width: view.frame.width, height: 100)
	}
}
