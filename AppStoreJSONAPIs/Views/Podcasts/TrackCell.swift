//
//  TrackCell.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 21.11.2022.
//

import UIKit

class TrackCell: UICollectionViewCell {
	
	let imageView = UIImageView(cornerRadius: 16)
	let nameLabel = UILabel(text: "Track Name", font: .boldSystemFont(ofSize: 16))
	let subtitleLabel = UILabel(text: "subtitle label", font: .systemFont(ofSize: 14), numberOfLines: 2)
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		imageView.image = #imageLiteral(resourceName: "garden")
		imageView.constrainWidth(constant: 80)
		
		let stackView = UIStackView(arrangedSubviews: [
			imageView,
			VerticalStackView(arrangedSubviews: [
				nameLabel,
				subtitleLabel
			], spacing: 4)
		], customSpacing: 16)
		
		addSubview(stackView)
		stackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
		stackView.alignment = .center
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
