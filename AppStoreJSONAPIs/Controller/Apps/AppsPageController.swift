//
//  AppsPageController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/22/22.
//

import UIKit

class AppsPageController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	fileprivate let cellId = "cellId"
	fileprivate let headerId = "headerId"
	
	var groups = [AppGroup]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
		
		fetchData()
	}
	
	
    fileprivate	func fetchData() {
		var group1: AppGroup?
		var group2: AppGroup?
		
		// help you sync your data fetches together
		let dispatchGroup = DispatchGroup()
		
		dispatchGroup.enter()
		Service.shared.fetchTopFreeApps { appGroup, err in
			dispatchGroup.leave()
			group1 = appGroup
		}
		dispatchGroup.enter()
		Service.shared.fetchTopPaidApps { appGroup, err in
			dispatchGroup.leave()
			group2 = appGroup
		}
		
		// completion
		dispatchGroup.notify(queue: .main) { [weak self] in
			guard let self = self else { return }
			if let group1 {
				self.groups.append(group1)
			}
			if let group2 {
				self.groups.append(group2)
			}
			self.collectionView.reloadData()
		}
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
		
		return header
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return .init(width: view.frame.width, height: 300)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return groups.count
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
		let group = groups[indexPath.item]
		
		cell.titleLabel.text = group.feed.title
		cell.horizontalController.appGroup = group
		cell.horizontalController.collectionView.reloadData()
		
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width, height: 300)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: 48, left: 0, bottom: 0, right: 0)
	}
	
}
