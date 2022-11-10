//
//  MultipleAppCell.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/10/22.
//

import UIKit

class MultipleAppCell: UICollectionViewCell {
	
	let appIconImageView = UIImageView(cornerRadius: 8)
	
	let nameLabel = UILabel(text: "AppName", font: .boldSystemFont(ofSize: 16), numberOfLines: 2)
	let companyLabel = UILabel(text: "CompanyName", font: .systemFont(ofSize: 13))
	
	let getButton = UIButton(title: "GET")
	
	let separatorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
		return view
	}()
	
	var app: FeedResult! {
		didSet {
			nameLabel.text = app.name
			companyLabel.text = app.artistName
			appIconImageView.sd_setImage(with: URL(string: app.artworkUrl100))
		}
	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		nameLabel.textColor = .black
		companyLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
		
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
		
		addSubview(separatorView)
		separatorView.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 0.5))
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
