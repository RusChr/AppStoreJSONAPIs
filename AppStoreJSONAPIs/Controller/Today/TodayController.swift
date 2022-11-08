//
//  TodayController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/7/22.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	fileprivate let cellId = "cellId"
	
	var appFullscreenController: AppFullscreenController!
	
	var startingFrame: CGRect?
	
	var topConstraint: NSLayoutConstraint?
	var leadingConstraint: NSLayoutConstraint?
	var widthConstraint: NSLayoutConstraint?
	var heightConstraint: NSLayoutConstraint?
	
	let items = [
		TodayItem(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white),
		TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9853675961, green: 0.967464149, blue: 0.7221172452, alpha: 1))
	]
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.isNavigationBarHidden = true
		
		collectionView.backgroundColor = .systemGray6
		collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let appFullscreenController = AppFullscreenController()
		appFullscreenController.todayItem = items[indexPath.row]
		appFullscreenController.dismissHandler = {
			self.handleRemoveRedView()
		}
		
		let fullscreenView = appFullscreenController.view!
		view.addSubview(fullscreenView)
		
		addChild(appFullscreenController)
		
		self.appFullscreenController = appFullscreenController
		
		guard let cell = collectionView.cellForItem(at: indexPath) else { return }
		
		// absolute coordinates of cell
		guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
		
		self.startingFrame = startingFrame
		
		// auto layout constraints animations
		// 4 anchors
		fullscreenView.translatesAutoresizingMaskIntoConstraints = false
		topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
		leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
		widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
		heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
		
		[topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach { $0?.isActive = true }
		self.view.layoutIfNeeded()
		//
		fullscreenView.layer.cornerRadius = 16
		
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
			
			self.topConstraint?.constant = 0
			self.leadingConstraint?.constant = 0
			self.widthConstraint?.constant = self.view.frame.width
			self.heightConstraint?.constant = self.view.frame.height
			
			self.view.layoutIfNeeded() // starts animation
			
			self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
		}

	}
	
	
	@objc func handleRemoveRedView() {
		self.navigationController?.navigationBar.isHidden = false
		
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
			self.appFullscreenController.tableView.contentOffset = .zero
			
			guard let startingFrame = self.startingFrame else { return }
			self.topConstraint?.constant = startingFrame.origin.y
			self.leadingConstraint?.constant = startingFrame.origin.x
			self.widthConstraint?.constant = startingFrame.width
			self.heightConstraint?.constant = startingFrame.height
			
			self.view.layoutIfNeeded()
			
			if let tabBarFrame = self.tabBarController?.tabBar.frame {
				self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
			}

		} completion: { _ in
			self.appFullscreenController.view.removeFromSuperview()
			self.appFullscreenController.removeFromParent()
		}
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
		cell.todayItem = items[indexPath.row]
		
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
