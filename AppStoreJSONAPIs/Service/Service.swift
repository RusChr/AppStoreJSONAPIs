//
//  Service.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/20/22.
//

import Foundation

class Service {
	
	static let shared = Service()
	
	
	private init() {}
	
	
	func fetchApps(completion: @escaping ([Result], Error?) -> Void) {
		let urlString = "https://itunes.apple.com/search?term=instagram&entity=software"
		guard let url = URL(string: urlString) else { return }

		URLSession.shared.dataTask(with: url) { data, resp, err in
			if let err = err {
				print("Failed to fetch apps:", err)
				completion([], nil)
				return
			}

			guard let data = data else { return }

			do {
				let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
				completion(searchResult.results, nil)
				
			} catch let jsonErr {
				completion([], jsonErr)
			}

		}.resume()
	}
}
