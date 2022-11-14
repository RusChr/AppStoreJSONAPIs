//
//  BackEnabledNavigationController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/14/22.
//

import UIKit

class BackEnabledNavigationController: UINavigationController, UIGestureRecognizerDelegate {
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.interactivePopGestureRecognizer?.delegate = self
	}
	
	
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return self.viewControllers.count > 1
	}
}
