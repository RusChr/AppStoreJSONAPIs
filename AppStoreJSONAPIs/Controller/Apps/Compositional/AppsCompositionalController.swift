//
//  AppsCompositionalView.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/25/22.
//

import SwiftUI

class AppsCompositionalController: UICollectionViewController {
	
	fileprivate let cellId = "cellId"
	fileprivate let smallCellId = "smallCellId"
	fileprivate let headerId = "headerId"
	
	fileprivate var socialApps = [SocialApp]()
	fileprivate var freeApps: AppGroup?
	fileprivate var paidApps: AppGroup?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Apps"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		collectionView.backgroundColor = .systemBackground
		collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: smallCellId)
		collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
		
		fetchApps()
	}
	
	
	private func fetchApps() {
		Service.shared.fetchSocialApps { apps, err in
			self.socialApps = apps ?? []
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
		
		Service.shared.fetchTopFreeApps { appGroup, err in
			self.freeApps = appGroup
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
		
		Service.shared.fetchTopPaidApps { appGroup, err in
			self.paidApps = appGroup
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 3
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if section == 0 {
			return socialApps.count
		} else if section == 1 {
			return freeApps?.feed.results.count ?? 0
		} else {
			return paidApps?.feed.results.count ?? 0
		}
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if indexPath.section == 0 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsHeaderCell
			let app = socialApps[indexPath.item]
			
			cell.titleLabel.text = app.tagline
			cell.companyLabel.text = app.name
			cell.imageView.sd_setImage(with: URL(string: app.imageUrl))
			
			return cell
			
		} else if indexPath.section == 1 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: smallCellId, for: indexPath) as! AppRowCell
			let app = freeApps?.feed.results[indexPath.item]
			
			cell.nameLabel.text = app?.name
			cell.companyLabel.text = app?.artistName
			cell.appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
			
			return cell
			
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: smallCellId, for: indexPath) as! AppRowCell
			let app = paidApps?.feed.results[indexPath.item]
			
			cell.nameLabel.text = app?.name
			cell.companyLabel.text = app?.artistName
			cell.appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
			
			return cell
		}
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let appId: String
		
		if indexPath.section == 0 {
			appId = socialApps[indexPath.item].id
		} else if indexPath.section == 1 {
			appId = freeApps?.feed.results[indexPath.item].id ?? ""
		} else {
			appId = paidApps?.feed.results[indexPath.item].id ?? ""
		}
		
		let appDetailController = AppDetailController(appId: appId)
		navigationController?.pushViewController(appDetailController, animated: true)
	}
	
	
	init() {
		let layout = UICollectionViewCompositionalLayout { sectionNumber, _ in
			if sectionNumber == 0 {
				return AppsCompositionalController.topSection()
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
}


struct AppsView: UIViewControllerRepresentable {
	typealias UIViewControllerType = UIViewController
	
	func makeUIViewController(context: Context) -> UIViewController {
		let controller = AppsCompositionalController()
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
