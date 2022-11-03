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
	
	
	func fetchJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> Void) {
		guard let url = URL(string: urlString) else { return }
		
		URLSession.shared.dataTask(with: url) { data, resp, err in
			if let err = err {
				completion(nil, err)
				return
			}
			
			guard let data = data else { return }
			
			do {
				let objects = try JSONDecoder().decode(T.self, from: data)
				completion(objects, nil)
			} catch let jsonErr {
				completion(nil, jsonErr)
			}
			
		}.resume()
	}
	
	
	func fetchApps(searchTerm: String, completion: @escaping (SearchResult?, Error?) -> Void) {
		let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
		
		fetchJSONData(urlString: urlString, completion: completion)
	}
	
	
	func fetchTopFreeApps(completion: @escaping (AppGroup?, Error?) -> Void) {
		let urlString = "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/10/apps.json"
		
		fetchAppGroup(urlString: urlString, completion: completion)
	}
	
	
	func fetchTopPaidApps(completion: @escaping (AppGroup?, Error?) -> Void) {
		let urlString = "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/10/apps.json"
		
		fetchAppGroup(urlString: urlString, completion: completion)
	}
	
	
	func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
		fetchJSONData(urlString: urlString, completion: completion)
	}
	
	
	func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
		let urlString = "https://api.letsbuildthatapp.com/appstore/social"
		
		fetchJSONData(urlString: urlString, completion: completion)
	}

}

