//
//  ReviewCell.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/3/22.
//

import UIKit

class ReviewCell: UICollectionViewCell {
	
	let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 18), numberOfLines: 2)
	let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 18))
	let starsLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 16))
	let bodyLabel = UILabel(text: "Review body\nReview body\nReview body", font: .systemFont(ofSize: 16), numberOfLines: 0)
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = #colorLiteral(red: 0.9385778308, green: 0.9328939319, blue: 0.9709507823, alpha: 1)
		layer.cornerRadius = 16
		clipsToBounds = true
		
		let stackView = VerticalStackView(arrangedSubviews: [
			UIStackView(arrangedSubviews: [
				titleLabel,
				UIView(),
				authorLabel
			]),
			starsLabel,
			bodyLabel,
			UIView()
		], spacing: 12)
		
		addSubview(stackView)
		stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
