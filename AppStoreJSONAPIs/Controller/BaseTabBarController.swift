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
			createNavController(viewController: TodayController(), title: "Today", imageName: "switch.programmable"),
			createNavController(viewController: AppsPageController(), title: "Apps", imageName: "apps.iphone"),
			createNavController(viewController: PodcastController(), title: "Podcasts", imageName: "mic.fill"),
			createNavController(viewController: AppsSearchController(), title: "Search", imageName: "magnifyingglass"),
			createNavController(viewController: AppsCompositionalController(), title: "AppsSUI", imageName: "swift")
		]
	}
	
	
	fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
		let navController = UINavigationController(rootViewController: viewController)
		navController.tabBarItem.title = title
		navController.tabBarItem.image = UIImage(systemName: imageName)
		navController.navigationBar.prefersLargeTitles = true
		viewController.navigationItem.title = title
		
		return navController
	}
}
