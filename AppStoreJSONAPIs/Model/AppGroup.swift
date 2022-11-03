//
//  AppGroup.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/30/22.
//

import Foundation

struct AppGroup: Decodable {
	let feed: Feed
}

struct Feed: Decodable {
	let title: String
	let results: [FeedResult]
}

struct FeedResult: Decodable {
	let id: String
	let artistName: String
	let name: String
	let artworkUrl100: String
	let url: String
}
