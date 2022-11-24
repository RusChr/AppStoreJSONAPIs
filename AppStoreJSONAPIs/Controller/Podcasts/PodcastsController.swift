//
//  PodcastsController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 21.11.2022.
//

import UIKit

class PodcastController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	fileprivate let cellId = "cellId"
	fileprivate let footerId = "footerId"
	fileprivate let searchTerm = "код"
	fileprivate var results = [Result]()
	
	var isPaginating = true
	var isDonePaginating = false
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.register(TrackCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(PodcastLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
		
		fetchData()
	}
	
	
	fileprivate func fetchData() {
		Service.shared.fetchSearchResult(term: searchTerm, entity: "podcast", offset: 0, limit: 25) { (searchResult: SearchResult?, err) in
			if let err = err {
				print("Failed to paginate data:", err)
				return
			}
			self.results = searchResult?.results ?? []
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return results.count
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrackCell
		let track = results[indexPath.item]
		cell.nameLabel.text = track.trackName
		cell.subtitleLabel.text = "\(track.artistName ?? "") • \(track.collectionName ?? "")"
		cell.imageView.sd_setImage(with: URL(string: track.artworkUrl100))
		
		// initiate paginate
		if indexPath.item == results.count - 1 && isPaginating {
			print("Fetch more data")
			
			Service.shared.fetchSearchResult(term: searchTerm, entity: "podcast", offset: results.count, limit: 25) { (searchResult: SearchResult?, err) in
				if let err = err {
					print("Failed to paginate data:", err)
					return
				}
				if searchResult?.results.count == 0 {
					self.isDonePaginating = true
				}
				sleep(2)
				
				self.results += searchResult?.results ?? []
				DispatchQueue.main.async {
					self.collectionView.reloadData()
				}
				self.isPaginating = false
			}
		}
		//
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width, height: 100)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
		return footer
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		let height: CGFloat = isDonePaginating ? 0 : 100
		return .init(width: view.frame.width, height: height)
	}
}
