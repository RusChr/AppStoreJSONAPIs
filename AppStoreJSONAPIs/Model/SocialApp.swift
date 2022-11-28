//
//  SocialApp.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 10/31/22.
//

import Foundation

struct SocialApp: Decodable, Hashable {
	let id: String
	let name: String
	let imageUrl: String
	let tagline: String
}
