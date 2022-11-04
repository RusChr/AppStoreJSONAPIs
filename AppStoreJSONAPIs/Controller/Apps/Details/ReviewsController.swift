//
//  ReviewsController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/3/22.
//

import UIKit

class ReviewsController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout {
	
	fileprivate let cellId = "cellId"
	
	var reviews: Reviews? {
		didSet {
			collectionView.reloadData()
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return reviews?.feed.entry.count ?? 0
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ReviewCell
		let review = reviews?.feed.entry[indexPath.item]
		
		cell.titleLabel.text = review?.title.label
		cell.authorLabel.text = review?.author.name.label
		cell.bodyLabel.text = review?.content.label
		
		if let ratingStr = review?.rating.label, let rating = Int(ratingStr) {
			let maxRating = max(5, rating)
			let arr = Array(repeating: "★", count: rating) + Array(repeating: "☆", count: maxRating - rating)
			cell.starsLabel.text = arr.joined()
		}
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width - 48, height: 250)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 16
	}
}
