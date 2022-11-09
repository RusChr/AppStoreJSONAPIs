//
//  TodayItem.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/8/22.
//

import UIKit

struct TodayItem {
	let category: String
	let title: String
	let image: UIImage
	let description: String
	let backgroundColor: UIColor
	
	let cellType: CellType
	
	enum CellType: String {
		case single, multiple
	}
}
