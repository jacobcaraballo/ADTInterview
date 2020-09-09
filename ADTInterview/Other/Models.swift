//
//  Models.swift
//  ADTInterview
//
//  Created by Jacob Caraballo on 9/8/20.
//  Copyright © 2020 AppsByJ. All rights reserved.
//

import Foundation
import UIKit


private var cachedImages = [String: UIImage]()

struct RMCharacter: Decodable {
	let name: String
	let species: String
	let image: String
	
	
	/// Requests and caches the image associated with this character.
	func getImage(_ handler: @escaping (UIImage?) -> ()) {
		if let cachedImage = cachedImages[self.image] { return handler(cachedImage) }
		guard let url = URL(string: self.image) else { return handler(nil) }
		let request = URLRequest(url: url)
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard error == nil,
				let data = data,
				let image = UIImage(data: data)
				else { return handler(nil) }
			
			DispatchQueue.main.async {
				cachedImages[self.image] = image
				handler(image)
			}
			
		}.resume()
	}
}

struct RMResult: Decodable {
	let id: Int
	let name: String
	let airDate: String
	let episode: String
	let characters: [String]
	let url: String
	let created: String
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case name = "name"
		case airDate = "air_date"
		case episode = "episode"
		case characters = "characters"
		case url = "url"
		case created = "created"
	}
	
}

struct RMInfo: Decodable {
	let count: Int
	let pages: Int
	let next: String
}

struct RMResponse: Decodable {
	let info: RMInfo
	let results: [RMResult]
}
