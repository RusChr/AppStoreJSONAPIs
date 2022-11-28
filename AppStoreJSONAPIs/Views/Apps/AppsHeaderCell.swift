//
//  AppsHeaderCell.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/24/22.
//

import UIKit

class AppsHeaderCell: UICollectionViewCell {
	
	let companyLabel = UILabel(text: "Facebook", font: .boldSystemFont(ofSize: 14))
	let titleLabel = UILabel(text: "Keeping up with friends is faster then ever", font: .systemFont(ofSize: 26))
	
	let imageView = UIImageView(cornerRadius: 8)
	
	var app: SocialApp! {
		didSet {
			companyLabel.text = app.name
			titleLabel.text = app.tagline
			imageView.sd_setImage(with: URL(string: app.imageUrl))
		}
	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		companyLabel.textColor = .systemBlue
		titleLabel.numberOfLines = 2
		imageView.image = #imageLiteral(resourceName: "holiday")
		
		let stackView = VerticalStackView(arrangedSubviews: [
			companyLabel,
			titleLabel,
			imageView
		], spacing: 16)
		addSubview(stackView)
		stackView.fillSuperview(padding: .init(top: 16, left: 0, bottom: 0, right: 0))
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
