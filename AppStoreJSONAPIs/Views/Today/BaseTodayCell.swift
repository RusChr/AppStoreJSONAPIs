//
//  BaseTodayCell.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/9/22.
//

import UIKit

class BaseTodayCell: UICollectionViewCell {
	
	var todayItem: TodayItem!
	
	override var isHighlighted: Bool {
		didSet {
			var transform: CGAffineTransform = .identity
			if isHighlighted {
				transform = .init(scaleX: 0.9, y: 0.9)
			}
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
				self.transform = transform
			}
			
		}
	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		layer.cornerRadius = 16
		layer.shadowOpacity = 0.1
		layer.shadowRadius = 10
		layer.shadowOffset = .init(width: 0, height: 10)
		//layer.shouldRasterize = true // Типа ускоряет анимацию (свойств слоя), но ухудшается качество текста, картинок. Чтобы не ломать, смотри костыль в 39 уроке.
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
