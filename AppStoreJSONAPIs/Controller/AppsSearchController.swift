//
//  AppsSearchController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/19/22.
//

import UIKit
import SDWebImage

class AppsSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
	
	fileprivate let cellId = "id1234"
	fileprivate var appResults = [Result]()
	fileprivate let searchController = UISearchController(searchResultsController: nil)
	
	var timer: Timer?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.backgroundColor = .white
		collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
		
		setupSearchBar()
		fetchITunesApps()
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
		
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
			DispatchQueue.main.async {
				self.fetchITunesApps(searchTerm: searchText)
			}
		})
	}
	
	
	fileprivate func fetchITunesApps(searchTerm: String = "instagram") {
		Service.shared.fetchApps(searchTerm: searchTerm) { [weak self] (result, err) in
			guard let self = self else { return }
			
			if let err = err {
				print("Failed to fetch apps:", err)
			}
			
			self.appResults = result
			
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width, height: 350)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return appResults.count
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
		cell.appResult = appResults[indexPath.item]
		
		return cell
	}
	
	
	init() {
		super.init(collectionViewLayout: UICollectionViewFlowLayout())
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
