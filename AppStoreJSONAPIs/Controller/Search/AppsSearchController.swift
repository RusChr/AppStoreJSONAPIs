//
//  AppsSearchController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/19/22.
//

import UIKit
import SDWebImage

class AppsSearchController: BaseListController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
	
	fileprivate let cellId = "id1234"
	fileprivate var appResults = [Result]()
	fileprivate let searchController = UISearchController(searchResultsController: nil)
	
	fileprivate let enterSearchTermLabel: UILabel = {
		let label = UILabel()
		label.text = "Enter search term above..."
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 20)
		return label
	}()
	
	var timer: Timer?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
		
		collectionView.addSubview(enterSearchTermLabel)
		enterSearchTermLabel.centerXInSuperview()
		enterSearchTermLabel.fillSuperview(padding: .init(top: 200, left: 0, bottom: 0, right: 0))
		
		setupSearchBar()
	}
	
	
	fileprivate func setupSearchBar() {
		definesPresentationContext = true
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self
	}
	
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		timer?.invalidate()
		
		timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
			DispatchQueue.main.async {
				self.fetchITunesApps(searchTerm: searchText)
			}
		})
	}
	
	
	fileprivate func fetchITunesApps(searchTerm: String = "instagram") {
		Service.shared.fetchSearchResult(term: searchTerm) { [weak self] (result, err) in
			guard let self = self else { return }
			
			if let err = err {
				print("\nFailed to fetch apps:", err)
				return
			}
			
			self.appResults = result?.results ?? []
			
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width, height: 350)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		enterSearchTermLabel.isHidden = appResults.count != 0
		return appResults.count
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
		cell.appResult = appResults[indexPath.item]
		
		return cell
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let appId = String(appResults[indexPath.item].trackId)
		let appDetailController = AppDetailController(appId: appId)
		navigationController?.pushViewController(appDetailController, animated: true)
	}
}
