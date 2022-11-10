//
//  TodayMultipleAppsController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/10/22.
//

import UIKit

class TodayMultipleAppsController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	fileprivate let cellId = "cellId"
	fileprivate let spacing: CGFloat = 16
	fileprivate let rowCount = 4
	
	var results = [FeedResult]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.backgroundColor = .clear
		collectionView.isScrollEnabled = false
		
		collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
		
		fetchData()
	}
	
	
	func fetchData() {
		Service.shared.fetchTopFreeApps { [weak self] (appGroup, err) in
			self?.results = appGroup?.feed.results ?? []
			DispatchQueue.main.async {
				self?.collectionView.reloadData()
			}
		}
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return min(rowCount, results.count)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MultipleAppCell
		cell.app = results[indexPath.item]
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let height: CGFloat = (view.frame.height - (spacing * CGFloat(rowCount - 1))) / CGFloat(rowCount)
		return .init(width: view.frame.width, height: height)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return spacing
	}
}
