//
//  ADTInterviewTests.swift
//  ADTInterviewTests
//
//  Created by Jacob Caraballo on 9/7/20.
//  Copyright © 2020 AppsByJ. All rights reserved.
//

import XCTest
@testable import ADTInterview

/*

{
	"info": {
		"count": 36,
		"pages": 2,
		"next": "https://rickandmortyapi.com/api/episode?page=2",
		"prev": null
	},
	"results": [
		{
			"id": 1,
			"name": "Pilot",
			"air_date": "December 2, 2013",
			"episode": "S01E01",
			"characters": [
				"https://rickandmortyapi.com/api/character/1",
				"https://rickandmortyapi.com/api/character/2",
				//...
			],
			"url": "https://rickandmortyapi.com/api/episode/1",
			"created": "2017-11-10T12:56:33.798Z"
		},
	// ...
	]
}



*/

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


class ADTInterviewTests: XCTestCase {

	func testRequest() {
		
		let expectation = XCTestExpectation()
		
		let page = 1
		let endpoint = "https://rickandmortyapi.com/api/episode/?page=\(page)"
		let url = URL(string: endpoint)
		XCTAssertNotNil(url)
		
		let request = URLRequest(url: url!)
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			
			XCTAssertNil(error, error!.localizedDescription)
			XCTAssertNotNil(data)
			
			let response = try? JSONDecoder().decode(RMResponse.self, from: data!)
			XCTAssertNotNil(response)
			print(response!.results)
			expectation.fulfill()
			
		}.resume()
		
		wait(for: [expectation], timeout: 5)
		
	}

}
