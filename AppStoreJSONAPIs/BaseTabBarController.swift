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
		
		let redViewController = UIViewController()
		redViewController.navigationItem.title = "Apps"
		redViewController.view.backgroundColor = .white
		
		let blueViewController = UIViewController()
		blueViewController.navigationItem.title = "Search"
		blueViewController.view.backgroundColor = .white
		
		let redNavController = UINavigationController(rootViewController: redViewController)
		redNavController.tabBarItem.title = "Apps"
		redNavController.tabBarItem.image = UIImage(named: "apps")
		redNavController.navigationBar.prefersLargeTitles = true
		
		let blueNavController = UINavigationController(rootViewController: blueViewController)
		blueNavController.tabBarItem.title = "Search"
		blueNavController.tabBarItem.image = UIImage(named: "search")
		blueNavController.navigationBar.prefersLargeTitles = true
				
		viewControllers = [
			redNavController,
			blueNavController
		]
	}
}
