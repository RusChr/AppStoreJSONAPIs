//
//  AppsCompositionalView.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/25/22.
//

import SwiftUI

class AppsCompositionalView: UICollectionViewController {
	
	fileprivate let cellId = "cellId"
	fileprivate let smallCellId = "smallCellId"
	fileprivate let headerId = "headerId"
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Apps"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		collectionView.backgroundColor = .systemBackground
		collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: smallCellId)
		collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
	}
	
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 4
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return section == 0 ? 5 : 8
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
		
		switch indexPath.section {
		case 0:
			break
		default:
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: smallCellId, for: indexPath)
		}
		
		return cell
	}
	
	
	init() {
		let layout = UICollectionViewCompositionalLayout { sectionNumber, _ in
			if sectionNumber == 0 {
				return AppsCompositionalView.topSection()
			} else {
				let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
				item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
				
				let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300)), subitems: [item])
				
				let section = NSCollectionLayoutSection(group: group)
				section.orthogonalScrollingBehavior = .groupPaging
				section.contentInsets.leading = 16
				
				section.boundarySupplementaryItems = [
					.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
				]
				
				return section
			}
		}
		
		super.init(collectionViewLayout: layout)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
		
		return header
	}
	
	
	static func topSection() -> NSCollectionLayoutSection {
		let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
		item.contentInsets.bottom = 16
		item.contentInsets.trailing = 16
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300)), subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .groupPaging
		section.contentInsets.leading = 16
		
		return section
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	class CompositionalHeader: UICollectionReusableView {
		
		let label = UILabel(text: "Editor's Choise Games", font: .boldSystemFont(ofSize: 24))
		
		
		override init(frame: CGRect) {
			super.init(frame: frame)
			
			addSubview(label)
			label.fillSuperview()
		}
		
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}


struct AppsView: UIViewControllerRepresentable {
	typealias UIViewControllerType = UIViewController
	
	
	func makeUIViewController(context: Context) -> UIViewController {
		let controller = AppsCompositionalView()
		
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
