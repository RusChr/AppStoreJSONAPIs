//
//  Podcasts.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 22.11.2022.
//

import Foundation

struct Podcast: Decodable {
	let feed: [Feed]
}
