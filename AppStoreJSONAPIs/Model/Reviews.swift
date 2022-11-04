//
//  Reviews.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/4/22.
//

import Foundation

struct Reviews: Decodable {
	let feed: ReviewFeed
}

struct ReviewFeed: Decodable {
	let entry: [Entry]
}

struct Entry: Decodable {
	let title: Label
	let content: Label
	let author: Author
	let rating: Label
	
	private enum CodingKeys: String, CodingKey {
		case title, content, author
		case rating = "im:rating"
	}
}

struct Label: Decodable {
	let label: String
}

struct Author: Decodable {
	let name: Label
}
