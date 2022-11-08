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
		
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.item == 0 {
			let headerCell = AppFullscreenHeaderCell()
			headerCell.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
			headerCell.todayCell.todayItem = todayItem
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
			return 450
		}
		return super.tableView(tableView, heightForRowAt: indexPath)
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
}
