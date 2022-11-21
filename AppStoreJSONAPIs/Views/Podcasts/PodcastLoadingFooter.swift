//
//  PodcastLoadingFooter.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 21.11.2022.
//

import UIKit

class PodcastLoadingFooter: UICollectionReusableView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let aiv = UIActivityIndicatorView(style: .large)
		aiv.color = .darkGray
		aiv.startAnimating()
		
		let label = UILabel(text: "Loading more...", font: .systemFont(ofSize: 16))
		label.textColor = .systemGray
		label.textAlignment = .center
		
		let stackView = VerticalStackView(arrangedSubviews: [
			aiv,
			label
		], spacing: 8)
		
		addSubview(stackView)
		stackView.centerInSuperview(size: .init(width: 200, height: 0))
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
