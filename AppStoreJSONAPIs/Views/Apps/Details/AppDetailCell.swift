//
//  AppDetailCell.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/2/22.
//

import UIKit

class AppDetailCell: UICollectionViewCell {
	
	let appIconImageView = UIImageView(cornerRadius: 16)
	
	let nameLabel = UILabel(text: "App name", font: .boldSystemFont(ofSize: 22), numberOfLines: 3)
	let whatsNewLabel = UILabel(text: "What's New", font: .boldSystemFont(ofSize: 22))
	var releaseNotesLabel = UILabel(text: "Release Notes", font: .systemFont(ofSize: 18), numberOfLines: 0)
	
	let priceButton = UIButton(title: "$4.99")
	
	var app: Result! {
		didSet {
			nameLabel.text = app?.trackName
			releaseNotesLabel.text = app?.releaseNotes
			appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
			priceButton.setTitle(app?.formattedPrice, for: .normal)
		}
	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		appIconImageView.layer.borderWidth = 0.5
		appIconImageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
		appIconImageView.constrainWidth(constant: 140)
		appIconImageView.constrainHeight(constant: 140)
		
		priceButton.backgroundColor = .systemBlue
		priceButton.setTitleColor(.white, for: .normal)
		priceButton.constrainHeight(constant: 32)
		priceButton.constrainWidth(constant: 80)
		priceButton.layer.cornerRadius = 16
		priceButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
		
		let stackView = VerticalStackView(arrangedSubviews: [
			UIStackView(arrangedSubviews: [
				appIconImageView,
				VerticalStackView(arrangedSubviews: [
					nameLabel,
					UIView(),
					UIStackView(arrangedSubviews: [
						priceButton,
						UIView()
					])
				], spacing: 12)
			], customSpacing: 20),
			whatsNewLabel,
			releaseNotesLabel
		], spacing: 20)
		
		addSubview(stackView)
		stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


extension UIStackView {
	convenience init(arrangedSubviews: [UIView], customSpacing: CGFloat = 0) {
		self.init(arrangedSubviews: arrangedSubviews)
		self.spacing = customSpacing
	}
}
