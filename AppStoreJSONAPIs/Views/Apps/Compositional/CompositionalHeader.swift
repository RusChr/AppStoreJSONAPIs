//
//  CompositionalHeader.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/28/22.
//

import UIKit

class CompositionalHeader: UICollectionReusableView {
	
	let label = UILabel(text: "Editor's Choise Apps", font: .boldSystemFont(ofSize: 24))
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(label)
		label.fillSuperview()
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
