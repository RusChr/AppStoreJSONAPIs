//
//  TodayController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/7/22.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
	
	static let cellSize: CGFloat = 500
	
	var appFullscreenController: AppFullscreenController!
	
	var appFullscreenBeginOffset: CGFloat = 0
	
	var startingFrame: CGRect?
	
	var anchoredConstraints: AnchoredConstraints?
	
	var items = [TodayItem]()
	
	let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
	
	let activityIndicatorView: UIActivityIndicatorView = {
		let aiv = UIActivityIndicatorView(style: .large)
		aiv.color = .systemGray
		aiv.startAnimating()
		aiv.hidesWhenStopped = true
		
		return aiv
	}()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(blurVisualEffectView)
		blurVisualEffectView.fillSuperview()
		blurVisualEffectView.alpha = 0
		
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
		switch items[indexPath.item].cellType {
		case .multiple:
			showDailyListFullscreen(indexPath)
		default:
			showSingleAppFullscreen(indexPath)
		}
	}
	
	
	fileprivate func showDailyListFullscreen(_ indexPath: IndexPath) {
		let fullController = TodayMultipleAppsController(mode: .fullscreen)
		fullController.apps = items[indexPath.item].apps
		let fullControllerNav = BackEnabledNavigationController(rootViewController: fullController)
		fullControllerNav.modalPresentationStyle = .fullScreen
		present(fullControllerNav, animated: true)
	}
	
	
	fileprivate func showSingleAppFullscreen(_ indexPath: IndexPath) {
		// #1
		setupSingleAppFullscreenController(indexPath)
		// #2 setup fullscreen in its starting position
		setupAppFullscreenStartingPosition(indexPath)
		// #3 begin the fullscreen animation
		beginAnimationAppFullscreen()
	}
	
	
	fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
		let appFullscreenController = AppFullscreenController()
		appFullscreenController.todayItem = items[indexPath.row]
		appFullscreenController.dismissHandler = {
			self.handleAppFullscreenDismissal()
		}
		appFullscreenController.view.layer.cornerRadius = 16
		self.appFullscreenController = appFullscreenController
		
		// #1 setup our pan gesture
		// Свайп вниз, чтобы закрыть открытый контроллер
		let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
		gesture.delegate = self
		appFullscreenController.view.addGestureRecognizer(gesture)
		
		// #2 add a blur effect view
		
		// #3 not to interfere with our UITableView scrolling
	}
	
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	
	@objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
		if gesture.state == .began {
			appFullscreenBeginOffset = appFullscreenController.tableView.contentOffset.y
		}
		
		if appFullscreenController.tableView.contentOffset.y > 0 {
			return
		}
		
		let translationY = gesture.translation(in: appFullscreenController.view).y
		let trueOffset = translationY - appFullscreenBeginOffset
		
		var scale = 1 - trueOffset / 1000
		scale = min(1, scale)
		scale = max(0.5, scale)
		
		let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
		
		if gesture.state == .changed && translationY > 0 {
			appFullscreenController.view.transform = transform
		} else if gesture.state == .ended && translationY > 0 {
			handleAppFullscreenDismissal()
		}
	}
	
	
	fileprivate func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
		let fullscreenView = appFullscreenController.view!
		view.addSubview(fullscreenView)
		addChild(appFullscreenController)
		
		self.collectionView.isUserInteractionEnabled = false
		
		setupStartingCellFrame(indexPath)
		
		// auto layout constraints animations
		// 4 anchors
		guard let startingFrame = self.startingFrame else { return }
		
		anchoredConstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
		
		self.view.layoutIfNeeded()
	}
	
	
	fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) else { return }
		
		// absolute coordinates of cell
		guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
		self.startingFrame = startingFrame
	}
	
	
	fileprivate func beginAnimationAppFullscreen() {
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
			self.anchoredConstraints?.top?.constant = 0
			self.anchoredConstraints?.leading?.constant = 0
			self.anchoredConstraints?.width?.constant = self.view.frame.width
			self.anchoredConstraints?.height?.constant = self.view.frame.height
			
			self.blurVisualEffectView.alpha = 1
			
			self.view.layoutIfNeeded() // starts animation
			
			self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
			
			guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
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
				let fullControllerNav = BackEnabledNavigationController(rootViewController: fullController)
				fullControllerNav.modalPresentationStyle = .fullScreen
				present(fullControllerNav, animated: true)
				return
			}
			superview = superview?.superview
		}
	}
	
	
	@objc func handleAppFullscreenDismissal() {
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
			self.appFullscreenController.tableView.contentOffset = .zero
			self.appFullscreenController.view.transform = .identity
			
			guard let startingFrame = self.startingFrame else { return }
			self.anchoredConstraints?.top?.constant = startingFrame.origin.y
			self.anchoredConstraints?.leading?.constant = startingFrame.origin.x
			self.anchoredConstraints?.width?.constant = startingFrame.width
			self.anchoredConstraints?.height?.constant = startingFrame.height
			
			self.blurVisualEffectView.alpha = 0
			
			self.view.layoutIfNeeded()
			
			if let tabBarFrame = self.tabBarController?.tabBar.frame {
				self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
			}
			
			guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
			cell.closeButton.alpha = 0
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
