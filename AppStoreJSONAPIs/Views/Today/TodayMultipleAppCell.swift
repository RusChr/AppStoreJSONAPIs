//
//  TodayMultipleAppCell.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/9/22.
//

import UIKit

class TodayMultipleAppCell: BaseTodayCell {
	
	let categoryLabel = UILabel(text: "THE DAILY LIST", font: .boldSystemFont(ofSize: 20))
	let titleLabel = UILabel(text: "Test-Drive These CarPlay Apps", font: .boldSystemFont(ofSize: 26), numberOfLines: 3)
	
	let multipleAppsController = UIViewController()
	
	override var todayItem: TodayItem! {
		didSet {
			categoryLabel.text = todayItem.category
			titleLabel.text = todayItem.title
			
			backgroundColor = todayItem.backgroundColor
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
		clipsToBounds = true
		layer.cornerRadius = 16
		
		let stackView = VerticalStackView(arrangedSubviews: [
			categoryLabel,
			titleLabel,
			multipleAppsController.view
		], spacing: 12)
		
		addSubview(stackView)
		stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
