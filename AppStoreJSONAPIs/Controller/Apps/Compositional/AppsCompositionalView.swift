//
//  AppsCompositionalView.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/25/22.
//

import SwiftUI

class CompositionalController: UICollectionViewController {
	
	fileprivate let cellId = "cellId"
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Apps"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		collectionView.backgroundColor = .systemBackground
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 8
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
		cell.backgroundColor = .red
		return cell
	}
	
	
	init() {
		super.init(collectionViewLayout: UICollectionViewFlowLayout())
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


struct AppsView: UIViewControllerRepresentable {
	typealias UIViewControllerType = UIViewController
	
	
	func makeUIViewController(context: Context) -> UIViewController {
		let controller = CompositionalController()
		
		return UINavigationController(rootViewController: controller)
	}
	
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
		
	}
}


struct AppsCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
			.edgesIgnoringSafeArea(.all)
    }
}
