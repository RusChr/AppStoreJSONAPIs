//
//  TodayController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/7/22.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	fileprivate let cellId = "cellId"
	
	var startingFrame: CGRect?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.isNavigationBarHidden = true
		
		collectionView.backgroundColor = .systemGray6
		
		collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let redView = UIView()
		redView.backgroundColor = .red
		redView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView)))
		view.addSubview(redView)
		
		guard let cell = collectionView.cellForItem(at: indexPath) else { return }
		
		// absolute coordinates of cell
		guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
		
		self.startingFrame = startingFrame
		redView.frame = startingFrame
		redView.layer.cornerRadius = 16
		
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn) {
			redView.frame = self.view.frame
		}

	}
	
	
	@objc func handleRemoveRedView(gesture: UITapGestureRecognizer) {
		// access to startingFrame
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
			gesture.view?.frame = self.startingFrame ?? .zero
		} completion: { _ in
			gesture.view?.removeFromSuperview()
		}

	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
		
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width - 64, height: 450)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 32
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: 32, left: 0, bottom: 32, right: 0)
	}
}
