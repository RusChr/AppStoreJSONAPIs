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
	
	
	func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> Void) {
		let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
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
				print("Fetching itunes apps from Service layer")
				completion(searchResult.results, nil)
			} catch let jsonErr {
				completion([], jsonErr)
			}

		}.resume()
	}
	
	
	func fetchTopFreeApps(completion: @escaping (AppGroup?, Error?) -> Void) {
		let urlString = "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/50/apps.json"
		
		fetchAppGroup(urlString: urlString, completion: completion)
	}
	
	
	func fetchTopPaidApps(completion: @escaping (AppGroup?, Error?) -> Void) {
		let urlString = "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/50/apps.json"
		
		fetchAppGroup(urlString: urlString, completion: completion)
	}
	
	
	func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
		guard let url = URL(string: urlString) else { return }
		
		URLSession.shared.dataTask(with: url) { data, resp, err in
			if let err = err {
				completion(nil, err)
				return
			}
			
			guard let data = data else { return }
			
			do {
				let appGroupResult = try JSONDecoder().decode(AppGroup.self, from: data)
				completion(appGroupResult, nil)
			} catch let jsonErr {
				completion(nil, jsonErr)
			}
			
		}.resume()
	}
	
	
	func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
		let urlString = "https://api.letsbuildthatapp.com/appstore/social"
		
		guard let url = URL(string: urlString) else { return }
		
		URLSession.shared.dataTask(with: url) { data, resp, err in
			if let err = err {
				completion(nil, err)
				return
			}
			
			guard let data = data else { return }
			
			do {
				let objects = try JSONDecoder().decode([SocialApp].self, from: data)
				completion(objects, nil)
			} catch let jsonErr {
				completion(nil, jsonErr)
			}
			
		}.resume()
	}
}

