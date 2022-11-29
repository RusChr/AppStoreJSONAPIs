//
//  AppsCompositionalView.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/25/22.
//

import SwiftUI

class AppsCompositionalController: UICollectionViewController {
	
	enum AppSection {
		case topSocial
		case topFree
		case topPaid
		case podcasts
	}
	
	fileprivate let cellId = "cellId"
	fileprivate let smallCellId = "smallCellId"
	fileprivate let headerId = "headerId"
	
	//fileprivate var socialApps = [SocialApp]()
	fileprivate var freeApps: AppGroup?
	fileprivate var paidApps: AppGroup?
	
	lazy var diffableDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable> = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
		
		if let socialApp = itemIdentifier as? SocialApp {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! AppsHeaderCell
			cell.app = socialApp
			
			return cell
			
		} else if let appGroup = itemIdentifier as? FeedResult {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.smallCellId, for: indexPath) as! AppRowCell
			cell.app = appGroup
			cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .primaryActionTriggered)
			
			return cell
		}
		
		return nil
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Apps"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		collectionView.backgroundColor = .systemBackground
		collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: smallCellId)
		collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
		
		collectionView.refreshControl = UIRefreshControl()
		collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
		
//		fetchApps()
		
		setupDiffableDataSource()
	}
	
	
	private func setupDiffableDataSource() {
		// adding data
//		var snapshot = diffableDataSource.snapshot()
//		snapshot.appendSections([.topSocial])
//		snapshot.appendItems([
//			SocialApp(id: "id0", name: "Facebook", imageUrl: "", tagline: "Whatever tagline you want"),
//			SocialApp(id: "id1", name: "Instagram", imageUrl: "", tagline: "tagline0")
//		], toSection: .topSocial)
//
//		diffableDataSource.apply(snapshot)
		
		diffableDataSource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath in
			let header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: self.headerId, for: indexPath) as! CompositionalHeader
			
			let snapshot = self.diffableDataSource.snapshot()
			let object = self.diffableDataSource.itemIdentifier(for: indexPath)
			let section = snapshot.sectionIdentifier(containingItem: object!)!
			
			if section == .topFree {
				header.label.text = "Top Free Apps"
			} else {
				header.label.text = "Top Paid Apps"
			}
			
			return header
		})
		
		fetchData()
	}
	
	
	fileprivate func fetchData() {
		var snapshot = self.diffableDataSource.snapshot()
		Service.shared.fetchSocialApps { socialApps, err in
			snapshot.appendSections([.topSocial])
			snapshot.appendItems(socialApps ?? [], toSection: .topSocial)
			self.diffableDataSource.apply(snapshot)
			
			Service.shared.fetchTopFreeApps { appGroup, err in
				snapshot.appendSections([.topFree])
				snapshot.appendItems(appGroup?.feed.results ?? [], toSection: .topFree)
				self.diffableDataSource.apply(snapshot)
			}
			Service.shared.fetchTopPaidApps { appGroup, err in
				snapshot.appendSections([.topPaid])
				snapshot.appendItems(appGroup?.feed.results ?? [], toSection: .topPaid)
				self.diffableDataSource.apply(snapshot)
			}
		}
	}
	
	
	@objc fileprivate func handleGet(button: UIView) {
		var superview = button.superview
		// to reach the parent cell of the get button
		while superview != nil {
			if let cell = superview as? UICollectionViewCell {
				guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
				guard let objectIClickedOnto = diffableDataSource.itemIdentifier(for: indexPath) else { return }
				
				var snapshot = diffableDataSource.snapshot()
				snapshot.deleteItems([objectIClickedOnto])
				diffableDataSource.apply(snapshot)
			}
			superview = superview?.superview
		}
	}
	
	
	@objc fileprivate func handleRefresh() {
		collectionView.refreshControl?.endRefreshing()
		
		var snapshot = diffableDataSource.snapshot()
		snapshot.deleteSections([.topSocial, .topFree, .topPaid])
		diffableDataSource.apply(snapshot)
		
		fetchData()
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let object = diffableDataSource.itemIdentifier(for: indexPath)
		if let object = object as? SocialApp {
			let appDetailController = AppDetailController(appId: object.id)
			navigationController?.pushViewController(appDetailController, animated: true)
		} else if let object = object as? FeedResult {
			let appDetailController = AppDetailController(appId: object.id)
			navigationController?.pushViewController(appDetailController, animated: true)
		}
	}
	
	
//	private func fetchApps() {
//		Service.shared.fetchSocialApps { apps, err in
//			self.socialApps = apps ?? []
//			DispatchQueue.main.async {
//				self.collectionView.reloadData()
//			}
//		}
//
//		Service.shared.fetchTopFreeApps { appGroup, err in
//			self.freeApps = appGroup
//			DispatchQueue.main.async {
//				self.collectionView.reloadData()
//			}
//		}
//
//		Service.shared.fetchTopPaidApps { appGroup, err in
//			self.paidApps = appGroup
//			DispatchQueue.main.async {
//				self.collectionView.reloadData()
//			}
//		}
//	}
	
	
//	override func numberOfSections(in collectionView: UICollectionView) -> Int {
//		return 0
//	}
	
	
//	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		if section == 0 {
//			return socialApps.count
//		} else if section == 1 {
//			return freeApps?.feed.results.count ?? 0
//		} else {
//			return paidApps?.feed.results.count ?? 0
//		}
//	}
	
	
//	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//		if indexPath.section == 0 {
//			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsHeaderCell
//			let app = socialApps[indexPath.item]
//
//			cell.titleLabel.text = app.tagline
//			cell.companyLabel.text = app.name
//			cell.imageView.sd_setImage(with: URL(string: app.imageUrl))
//
//			return cell
//
//		} else if indexPath.section == 1 {
//			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: smallCellId, for: indexPath) as! AppRowCell
//			let app = freeApps?.feed.results[indexPath.item]
//
//			cell.nameLabel.text = app?.name
//			cell.companyLabel.text = app?.artistName
//			cell.appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
//
//			return cell
//
//		} else {
//			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: smallCellId, for: indexPath) as! AppRowCell
//			let app = paidApps?.feed.results[indexPath.item]
//
//			cell.nameLabel.text = app?.name
//			cell.companyLabel.text = app?.artistName
//			cell.appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
//
//			return cell
//		}
//	}
	
	
//	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		let appId: String
//
//		if indexPath.section == 0 {
//			appId = socialApps[indexPath.item].id
//		} else if indexPath.section == 1 {
//			appId = freeApps?.feed.results[indexPath.item].id ?? ""
//		} else {
//			appId = paidApps?.feed.results[indexPath.item].id ?? ""
//		}
//
//		let appDetailController = AppDetailController(appId: appId)
//		navigationController?.pushViewController(appDetailController, animated: true)
//	}
	
	
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
	
	
//	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CompositionalHeader
//		var title: String?
//
//		if indexPath.section == 1 {
//			title = freeApps?.feed.title
//		} else if indexPath.section == 2 {
//			title = paidApps?.feed.title
//		}
//		header.label.text = title
//
//		return header
//	}
	
	
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
