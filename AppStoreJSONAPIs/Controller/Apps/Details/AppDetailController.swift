//
//  AppDetailController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/2/22.
//

import UIKit

class AppDetailController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	fileprivate let appId: String
	
	fileprivate let appDetailCellId = "appDetailCellId"
	fileprivate let previewCellId = "previewCellId"
	fileprivate let reviewRowCellId = "reviewRowCellId"
	
	var app: Result?
	var reviews: Reviews?
	var reviewsRu: Reviews?
	
	
	// dependency injection constructor
	init(appId: String) {
		self.appId = appId
		super.init()
	}
	//
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.largeTitleDisplayMode = .never
		
		collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: appDetailCellId)
		collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCellId)
		collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: reviewRowCellId)
		
		fetchData()
	}
	
	
	fileprivate func fetchData() {
		let urlString = "https://itunes.apple.com/lookup?id=\(appId)"
		Service.shared.fetchJSONData(urlString: urlString) { [weak self] (result: SearchResult?, err) in
			self?.app = result?.results.first
			DispatchQueue.main.async {
				self?.collectionView.reloadData()
			}
		}
		
		let reviewsUrl = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId)/sortby=mostrecent/json?l=en&cc=us"
		Service.shared.fetchJSONData(urlString: reviewsUrl) { [weak self] (reviews: Reviews?, err) in
			if let err {
				print("Failed to decode reviews:", err)
				return
			}
			self?.reviews = reviews
			DispatchQueue.main.async {
				self?.collectionView.reloadData()
			}
		}
		
		let reviewsRuUrl = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId)/sortby=mostrecent/json?l=en&cc=ru"
		Service.shared.fetchJSONData(urlString: reviewsRuUrl) { [weak self] (reviews: Reviews?, err) in
			if let err {
				print("Failed to decode reviews:", err)
				return
			}
			self?.reviewsRu = reviews
			DispatchQueue.main.async {
				self?.collectionView.reloadData()
			}
		}
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let appDetailCell = collectionView.dequeueReusableCell(withReuseIdentifier: appDetailCellId, for: indexPath) as! AppDetailCell
		let previewCell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as! PreviewCell
		let reviewRowCell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewRowCellId, for: indexPath) as! ReviewRowCell
		
		appDetailCell.app = app
		previewCell.horizontalController.app = app
		reviewRowCell.reviewsController.reviews = reviews
		reviewRowCell.reviewsController.reviews = reviewsRu
		
		switch indexPath.item {
		case 0:
			return appDetailCell
		case 1:
			return previewCell
		case 2:
			return reviewRowCell
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
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: 0, left: 0, bottom: 16, right: 0)
	}
}
