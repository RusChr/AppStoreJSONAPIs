//
//  BaseTabBarController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/18/22.
//

import UIKit

class BaseTabBarController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		viewControllers = [
			createNavController(viewController: TodayController(), title: "Today", imageName: "today_icon"),
			createNavController(viewController: AppsPageController(), title: "Apps", imageName: "apps"),
			createNavController(viewController: AppsSearchController(), title: "Search", imageName: "search")
		]
		
	}
	
	
	fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
		let navController = UINavigationController(rootViewController: viewController)
		navController.tabBarItem.title = title
		navController.tabBarItem.image = UIImage(named: imageName)
		navController.navigationBar.prefersLargeTitles = true
		
		viewController.navigationItem.title = title
		
		return navController
	}
}
