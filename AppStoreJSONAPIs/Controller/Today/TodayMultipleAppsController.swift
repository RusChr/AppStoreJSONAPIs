//
//  TodayMultipleAppsController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/10/22.
//

import UIKit

class TodayMultipleAppsController: BaseListController, UICollectionViewDelegateFlowLayout {

	fileprivate let cellId = "cellId"
	fileprivate let spacing: CGFloat = 16
	fileprivate let rowCount = 4
	
	fileprivate let mode: Mode
	var apps = [FeedResult]()
	
	let closeButton: UIButton = {
		let button = UIButton(type: .close)
		return button
	}()
	
	enum Mode {
		case small, fullscreen
	}
	
	override var prefersStatusBarHidden: Bool { return true }
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if mode == .fullscreen {
			setupCloseButton()
			navigationController?.isNavigationBarHidden = true
//			navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
		} else {
			collectionView.isScrollEnabled = false
		}
		
		collectionView.backgroundColor = .white
		collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
	}
	
	
	fileprivate func setupCloseButton() {
		view.addSubview(closeButton)
		closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
		closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 48, left: 0, bottom: 0, right: 16), size: .init(width: 32, height: 32))
	}
	
	
	@objc func handleDismiss() {
		dismiss(animated: true)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if mode == .fullscreen {
			return apps.count
		}
		return min(rowCount, apps.count)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MultipleAppCell
		cell.app = apps[indexPath.item]
		return cell
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let appId = apps[indexPath.item].id
		let appDetailController = AppDetailController(appId: appId)
		navigationController?.pushViewController(appDetailController, animated: true)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var height: CGFloat = (view.frame.height - (spacing * CGFloat(rowCount - 1))) / CGFloat(rowCount)
		var width: CGFloat = view.frame.width
		
		if mode == .fullscreen {
			height = 64
			width = width - 48
		}
		return .init(width: width, height: height)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return spacing
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		if mode == .fullscreen {
			return .init(top: 24, left: 24, bottom: 12, right: 24)
		}
		
		return .zero
	}
	
	
	init(mode: Mode) {
		self.mode = mode
		super.init()
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
}
