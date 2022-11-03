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
	fileprivate let reviewCellId = "reviewCellId"
	
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
		collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: reviewCellId)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! AppDetailCell
		let previewCell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as! PreviewCell
		let reviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! ReviewRowCell
		
		detailCell.app = app
		previewCell.horizontalController.app = app
		
		switch indexPath.item {
		case 0:
			return detailCell
		case 1:
			return previewCell
		case 2:
			return reviewCell
		default:
			return UICollectionViewCell()
		}
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		// calculate the nessesery size for our cell
		let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
		dummyCell.app = app
		dummyCell.layoutIfNeeded()
		
		let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
		//
		
		switch indexPath.item {
		case 0:
			return .init(width: view.frame.width, height: estimatedSize.height)
		case 1:
			return .init(width: view.frame.width, height: 500)
		case 2:
			return .init(width: view.frame.width, height: 280)
		default:
			return .zero
		}
	}
}
