//
//  AppRowCell.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/22/22.
//

import UIKit

class AppRowCell: UICollectionViewCell {
	
	let appIconImageView = UIImageView(cornerRadius: 8)
	
	let nameLabel = UILabel(text: "AppName", font: .systemFont(ofSize: 20))
	let companyLabel = UILabel(text: "CompanyName", font: .systemFont(ofSize: 13))
	
	let getButton = UIButton(title: "GET")
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		appIconImageView.backgroundColor = .purple
		appIconImageView.layer.borderWidth = 0.5
		appIconImageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
		appIconImageView.constrainWidth(constant: 64)
		appIconImageView.constrainHeight(constant: 64)
		
		getButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
		getButton.setTitleColor(.systemBlue, for: .normal)
		getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
		getButton.constrainWidth(constant: 80)
		getButton.constrainHeight(constant: 32)
		getButton.layer.cornerRadius = 16
		
		let stackView = UIStackView(arrangedSubviews: [
			appIconImageView,
			VerticalStackView(arrangedSubviews: [
				nameLabel, companyLabel
			], spacing: 4),
			getButton
		])
		addSubview(stackView)
		stackView.alignment = .center
		stackView.spacing = 16
		stackView.fillSuperview()
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
