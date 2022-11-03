//
//  AppDetailController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/2/22.
//

import UIKit

class AppDetailController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	fileprivate let detailCellId = "detailCellId"
	fileprivate let previewCellId = "previewCellId"
	
	var app: Result?
	
	var appId: String! {
		didSet {
			let urlString = "https://itunes.apple.com/lookup?id=\(appId ?? "")"
			Service.shared.fetchJSONData(urlString: urlString) { [weak self] (result: SearchResult?, err) in
				self?.app = result?.results.first
				DispatchQueue.main.async {
					self?.collectionView.reloadData()
				}
			}
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.largeTitleDisplayMode = .never
		
		collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: detailCellId)
		collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCellId)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 2
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! AppDetailCell
		let previewCell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as! PreviewCell
		
		detailCell.app = app
		previewCell.horizontalController.app = app
		
		return indexPath.item == 0 ? detailCell : previewCell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if indexPath.item == 0 {
			// calculate the nessesery size for our cell
			let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
			dummyCell.app = app
			dummyCell.layoutIfNeeded()
			
			let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
			//
			return .init(width: view.frame.width, height: estimatedSize.height)
		} else {
			return .init(width: view.frame.width, height: 500)
		}
	}
}
