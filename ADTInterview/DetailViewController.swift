//
//  DetailViewController.swift
//  ADTInterview
//
//  Created by Jacob Caraballo on 9/8/20.
//  Copyright © 2020 AppsByJ. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
	
	var result: RMResult!
	var headerTitleView: HeaderTitleView!
	
	let tableView = UITableView()
	var characters = [String: RMCharacter]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		overrideUserInterfaceStyle = .dark
		view.backgroundColor = UIColor(white: 0.05, alpha: 1)
		
		loadCharacters()
		setupHeaderView()
		setupTableView()
		setupDismissButton()
	}
	
	private func setupDismissButton() {
		
		let button = UIButton(type: .system)
		button.setTitle("Dismiss", for: .normal)
		button.sizeToFit()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
		view.addSubview(button)
		
		let edgePadding: CGFloat = 20
		NSLayoutConstraint.activate([
		
			button.topAnchor.constraint(equalTo: view.topAnchor, constant: edgePadding),
			button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgePadding)
			
		])
		
	}
	
	private func setupHeaderView() {
		
		headerTitleView = HeaderTitleView(
			title: result.episode,
			detail: """
			\(result.name)
			\(result.airDate)
			""",
			safeAreaTopPadding: 0)
		headerTitleView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(headerTitleView)
		
		
		NSLayoutConstraint.activate([
			
			headerTitleView.widthAnchor.constraint(equalTo: view.widthAnchor),
			headerTitleView.heightAnchor.constraint(equalToConstant: headerTitleView.expectedHeight),
			headerTitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			headerTitleView.topAnchor.constraint(equalTo: view.topAnchor)
			
		])
		
	}
	
	private func setupTableView() {
		
		tableView.backgroundColor = nil
		tableView.register(CharacterCell.self, forCellReuseIdentifier: "CharacterCell")
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.separatorStyle = .none
		tableView.delegate = self
		tableView.dataSource = self
		view.insertSubview(tableView, belowSubview: headerTitleView)
		
		
		NSLayoutConstraint.activate([
			
			tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
			tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			tableView.topAnchor.constraint(equalTo: headerTitleView.bottomAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			
		])
		
	}
	
}



/* * * * * * * * * * * * * * * * * * * * * * * *
 *
 *	Other Functions
 *
 */
extension DetailViewController {
	
	@objc private func dismissButtonPressed() {
		dismiss(animated: true, completion: nil)
	}
	
	private func loadCharacters() {
		
		for character in result.characters {
			DispatchQueue.global(qos: .background).async {
				self.request(character: character)
			}
		}
		
	}
	
	private func request(character: String) {
		guard let url = URL(string: character)
			else { return }
		let request = URLRequest(url: url)
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard error == nil,
				let data = data,
				let response = try? JSONDecoder().decode(RMCharacter.self, from: data)
				else { return }
			self.characters[character] = response
			
			DispatchQueue.main.async {
				guard let indexPath = self.indexPath(for: character),
					self.tableView.indexPathsForVisibleRows?.contains(indexPath) == true
					else { return }
				self.tableView.reloadRows(at: [indexPath], with: .automatic)
			}
		}.resume()
	}
	
	private func indexPath(for character: String) -> IndexPath? {
		guard let index = result.characters.firstIndex(of: character)
			else { return nil }
		return IndexPath(row: index, section: 0)
	}
	
}



/* * * * * * * * * * * * * * * * * * * * * * * *
 *
 *	TableView Delegate & DataSource
 *
 */
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return result.characters.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
		let resultKey = self.result.characters[indexPath.row]
		
		if let result = self.characters[resultKey] {
			
			result.getImage { (image) in
				cell.characterImageView.image = image
			}
			
			cell.nameLabel.text = result.name
			cell.speciesLabel.text = result.species
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
	
	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? CharacterCell else { return }
		cell.highlight()
	}
	
	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? CharacterCell else { return }
		cell.unhighlight()
	}
	
}
