//
//  TodayController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/7/22.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	static let cellSize: CGFloat = 500
	
	var appFullscreenController: AppFullscreenController!
	
	var startingFrame: CGRect?
	
	var topConstraint: NSLayoutConstraint?
	var leadingConstraint: NSLayoutConstraint?
	var widthConstraint: NSLayoutConstraint?
	var heightConstraint: NSLayoutConstraint?
	
//	let items = [
//		TodayItem(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cellType: .single),
//		TodayItem(category: "THE DAILY LIST", title: "Test-Drive These CarPlay Apps", image: UIImage(), description: "", backgroundColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), cellType: .multiple),
//		TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9853675961, green: 0.967464149, blue: 0.7221172452, alpha: 1), cellType: .single),
//		TodayItem(category: "THE SECOND DAILY LIST", title: "Test-Drive These CarPlay Apps", image: UIImage(), description: "", backgroundColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), cellType: .multiple)
//	]
	
	var items = [TodayItem]()
	
	let activityIndicatorView: UIActivityIndicatorView = {
		let aiv = UIActivityIndicatorView(style: .large)
		aiv.color = .systemGray
		aiv.startAnimating()
		aiv.hidesWhenStopped = true
		
		return aiv
	}()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(activityIndicatorView)
		activityIndicatorView.centerInSuperview()
		
		fetchData()
		
		navigationController?.isNavigationBarHidden = true
		
		collectionView.backgroundColor = .systemGray6
		collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
		collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		tabBarController?.tabBar.superview?.setNeedsLayout()
	}
	
	
	fileprivate func fetchData() {
		let dispatchGroup = DispatchGroup()
		var topFreeAppGroup: AppGroup?
		var topPaidAppGroup: AppGroup?
		
		dispatchGroup.enter()
		Service.shared.fetchTopFreeApps { (appGroup, err) in
			topFreeAppGroup = appGroup
			dispatchGroup.leave()
		}
		
		dispatchGroup.enter()
		Service.shared.fetchTopPaidApps { (appGroup, err) in
			topPaidAppGroup = appGroup
			dispatchGroup.leave()
		}
		
		// completion block
		dispatchGroup.notify(queue: .main) { [weak self] in
			self?.items = [
				TodayItem(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cellType: .single, apps: []),
				
				TodayItem(category: "DAILY LIST", title: topFreeAppGroup?.feed.title ?? "", image: UIImage(), description: "", backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cellType: .multiple, apps: topFreeAppGroup?.feed.results ?? []),
				
				TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9853675961, green: 0.967464149, blue: 0.7221172452, alpha: 1), cellType: .single, apps: []),
				
				TodayItem(category: "DAILY LIST", title: topPaidAppGroup?.feed.title ?? "", image: UIImage(), description: "", backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cellType: .multiple, apps: topPaidAppGroup?.feed.results ?? [])
			]
			
			self?.activityIndicatorView.stopAnimating()
			self?.collectionView.reloadData()
		}
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if items[indexPath.item].cellType == .multiple {
			let fullController = TodayMultipleAppsController(mode: .fullscreen)
			fullController.apps = items[indexPath.item].apps
			present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
			return
		}
		
		let appFullscreenController = AppFullscreenController()
		appFullscreenController.todayItem = items[indexPath.row]
		appFullscreenController.dismissHandler = {
			self.handleRemoveFullscreenController()
		}
		
		let fullscreenView = appFullscreenController.view!
		view.addSubview(fullscreenView)
		
		addChild(appFullscreenController)
		
		self.appFullscreenController = appFullscreenController
		
		self.collectionView.isUserInteractionEnabled = false
		
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
			
			guard let cell = appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
			cell.todayCell.topConstraint.constant = 64
			cell.layoutIfNeeded()
		}

	}
	
	
	@objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
		let collectionView = gesture.view
		// figure out wich cell (DAILY LIST) were clicking into
		var superview = collectionView?.superview
		while superview != nil {
			if let cell = superview as? TodayMultipleAppCell {
				guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
				let apps = items[indexPath.item].apps
				let fullController = TodayMultipleAppsController(mode: .fullscreen)
				fullController.apps = apps
				present(fullController, animated: true)
				return
			}
			superview = superview?.superview
		}
		//
	}
	
	
	@objc func handleRemoveFullscreenController() {
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
			
			guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
			cell.todayCell.topConstraint.constant = 24
			cell.layoutIfNeeded()

		} completion: { _ in
			self.appFullscreenController.view.removeFromSuperview()
			self.appFullscreenController.removeFromParent()
			self.collectionView.isUserInteractionEnabled = true
		}
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cellId = items[indexPath.item].cellType.rawValue
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
		cell.todayItem = items[indexPath.item]
		
		if let cell = cell as? TodayMultipleAppCell {
			cell.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
		}
		
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width - 64, height: TodayController.cellSize)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 32
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: 32, left: 0, bottom: 32, right: 0)
	}
}
