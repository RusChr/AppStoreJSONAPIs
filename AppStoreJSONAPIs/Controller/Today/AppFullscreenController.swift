//
//  AppFullscreenController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/7/22.
//

import UIKit

class AppFullscreenController: UITableViewController {
	
	var dismissHandler: (() -> Void)?
	var todayItem: TodayItem?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.clipsToBounds = true
		
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		tableView.contentInsetAdjustmentBehavior = .never
		// Чтобы снизу был отступ. Из-за депрекейта. Жесть.
		let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
		let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? .zero
		tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
		//
	}
	
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y < 0 {
			scrollView.isScrollEnabled = false
			scrollView.isScrollEnabled = true
		}
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.item == 0 {
			let headerCell = AppFullscreenHeaderCell()
			headerCell.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
			headerCell.todayCell.todayItem = todayItem
			headerCell.todayCell.layer.cornerRadius = 0
			headerCell.clipsToBounds = true
			headerCell.backgroundView = nil
			return headerCell
		}
		return AppFullscreenDescriptionCell()
	}
	
	
	@objc func handleDismiss(button: UIButton) {
		button.isHidden = true
		dismissHandler?()
	}
	
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return TodayController.cellSize
		}
		return super.tableView(tableView, heightForRowAt: indexPath)
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
}
