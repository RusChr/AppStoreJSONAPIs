//
//  ReviewCell.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/3/22.
//

import UIKit

class ReviewCell: UICollectionViewCell {
	
	let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 16))
	let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
	let starsLabel = UILabel(text: "0", font: .systemFont(ofSize: 18))
	let bodyLabel = UILabel(text: "Review body\nReview body\nReview body", font: .systemFont(ofSize: 14), numberOfLines: 8)
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .systemGray6
		layer.cornerRadius = 16
		clipsToBounds = true
		
		let stackView = VerticalStackView(arrangedSubviews: [
			UIStackView(arrangedSubviews: [
				titleLabel,
				authorLabel
			], customSpacing: 16),
			starsLabel,
			bodyLabel
		], spacing: 12)
		
		starsLabel.textColor = .systemOrange
		
		authorLabel.textColor = .darkGray
		authorLabel.textAlignment = .right
		
		titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
		
		addSubview(stackView)
		stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
