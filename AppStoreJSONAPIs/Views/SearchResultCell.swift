//
//  SearchResultCell.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/19/22.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
	
	var appResult: Result! {
		didSet {
			let appIconUrl = URL(string: appResult.artworkUrl100)
			
			appIconImageView.sd_setImage(with: appIconUrl)
			nameLabel.text = appResult.trackName
			categoryLabel.text = appResult.primaryGenreName
			ratingsLabel.text = String(format: "%.2f", appResult.averageUserRating ?? 0)
			
			screenshot1ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[0]))
			if appResult.screenshotUrls.count > 1 {
				screenshot2ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[1]))
			}
			if appResult.screenshotUrls.count > 2 {
				screenshot3ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[2]))
			}
		}
	}
	
	let appIconImageView: UIImageView = {
		let iv = UIImageView()
		iv.constrainWidth(constant: 64)
		iv.constrainHeight(constant: 64)
		iv.layer.cornerRadius = 12
		iv.clipsToBounds = true
		return iv
	}()
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "AppName"
		return label
	}()
	
	let categoryLabel: UILabel = {
		let label = UILabel()
		label.text = "CategoryName"
		return label
	}()
	
	let ratingsLabel: UILabel = {
		let label = UILabel()
		label.text = "9.99"
		return label
	}()
	
	let getButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("GET", for: .normal)
		button.setTitleColor(.systemBlue, for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 16)
		button.backgroundColor = UIColor(white: 0.95, alpha: 1)
		button.constrainWidth(constant: 80)
		button.constrainHeight(constant: 32)
		button.layer.cornerRadius = 16
		return button
	}()
	
	lazy var screenshot1ImageView = createScreenshotImageView()
	lazy var screenshot2ImageView = createScreenshotImageView()
	lazy var screenshot3ImageView = createScreenshotImageView()
	
	
	func createScreenshotImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.layer.borderWidth = 0.5
		imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
		imageView.layer.cornerRadius = 8
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFit
		return imageView
	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let labelsStackView = VerticalStackView(arrangedSubviews: [
			nameLabel, categoryLabel, ratingsLabel
		])
		
		let infoTopStackView = UIStackView(arrangedSubviews: [
			appIconImageView, labelsStackView, getButton
		])
		infoTopStackView.spacing = 12
		infoTopStackView.alignment = .center
		
		let screenshotsStackView = UIStackView(arrangedSubviews: [
			screenshot1ImageView, screenshot2ImageView, screenshot3ImageView
		])
		screenshotsStackView.spacing = 12
		screenshotsStackView.distribution = .fillEqually
		
		let overallStackView = VerticalStackView(arrangedSubviews: [
			infoTopStackView, screenshotsStackView
		], spacing: 16)
		
		addSubview(overallStackView)
		overallStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

