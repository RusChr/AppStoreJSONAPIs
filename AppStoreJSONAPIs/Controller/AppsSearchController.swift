//
//  AppsSearchController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/19/22.
//

import UIKit

class AppsSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	fileprivate let cellId = "id1234"
	fileprivate var appResults = [Result]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.backgroundColor = .white
		collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
		
		fetchITunesApps()
	}
	
	
	fileprivate func fetchITunesApps() {
		Service.shared.fetchApps { [weak self] (result, err) in
			guard let self = self else { return }
			
			if let err = err {
				print("Failed to fetch apps:", err)
			}
			
			self.appResults = result
			
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width, height: 350)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return appResults.count
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
		let appResult = appResults[indexPath.item]
		
		cell.nameLabel.text = appResult.trackName
		cell.categoryLabel.text = appResult.primaryGenreName
		cell.ratingsLabel.text = "\(String(describing: appResult.averageUserRating ?? 0))"
		
		return cell
	}
	
	
	init() {
		super.init(collectionViewLayout: UICollectionViewFlowLayout())
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
