//
//  AppDetailController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/2/22.
//

import UIKit

class AppDetailController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	fileprivate let detailCellId = "detailCellId"
	
	var appId: String! {
		didSet {
			let urlString = "https://itunes.apple.com/lookup?id=\(appId ?? "")"
			Service.shared.fetchJSONData(urlString: urlString) { (result: SearchResult?, err) in
				print(result?.results.first?.releaseNotes ?? "default release notes")
			}
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.largeTitleDisplayMode = .never
		
		collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: detailCellId)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 1
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! AppDetailCell
		
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width, height: 300)
	}
}
