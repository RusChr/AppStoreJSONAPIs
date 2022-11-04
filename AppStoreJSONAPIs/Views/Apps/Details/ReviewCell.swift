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
	let starsLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 16))
	let bodyLabel = UILabel(text: "Review body\nReview body\nReview body", font: .systemFont(ofSize: 16), numberOfLines: 0)
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = #colorLiteral(red: 0.9779326825, green: 0.9569294637, blue: 0.9476141073, alpha: 1)
		layer.cornerRadius = 16
		clipsToBounds = true
		
		authorLabel.textColor = .darkGray
		
		let stackView = VerticalStackView(arrangedSubviews: [
			UIStackView(arrangedSubviews: [
				titleLabel,
				authorLabel
			], customSpacing: 16),
			starsLabel,
			bodyLabel,
			UIView()
		], spacing: 12)
		
		authorLabel.textAlignment = .right
		titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
		
		addSubview(stackView)
		stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
