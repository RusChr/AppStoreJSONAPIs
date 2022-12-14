//
//  SearchResult.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/20/22.
//

import Foundation

struct SearchResult: Decodable {
	let resultCount: Int
	let results: [Result]
}

struct Result: Decodable, Hashable {
	let trackId: Int
	let trackName: String
	let primaryGenreName: String
	let averageUserRating: Float?
	let screenshotUrls: [String]?
	let artworkUrl100: String
	let formattedPrice: String?
	let description: String?
	let releaseNotes: String?
	let artistName: String?
	let collectionName: String?
}
