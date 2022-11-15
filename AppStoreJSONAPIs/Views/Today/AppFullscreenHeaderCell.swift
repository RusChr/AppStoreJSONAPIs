//
//  AppFullscreenHeaderCell.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/7/22.
//

import UIKit

class AppFullscreenHeaderCell: UITableViewCell {
	
	let todayCell = TodayCell()
	
	let closeButton: UIButton = {
		let button = UIButton(type: .close)
		return button
	}()
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		contentView.addSubview(todayCell)
		todayCell.fillSuperview()
		
		contentView.addSubview(closeButton)
		closeButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 48, left: 0, bottom: 0, right: 12), size: .init(width: 32, height: 32))
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
