//
//  ViewController.swift
//  ADTInterview
//
//  Created by Jacob Caraballo on 9/7/20.
//  Copyright © 2020 AppsByJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	let tableView = UITableView()
	let headerTitleView = HeaderTitleView(
		title: "Rick & Morty",
		detail: "Rick is a mentally-unbalanced but scientifically-gifted old man who has recently reconnected with his family. He spends most of his time involving his young grandson Morty in dangerous, outlandish adventures throughout space and alternate universes. Compounded with Morty's already unstable family life, these events cause Morty much distress at home and school."
	)
	let bgImageView = UIImageView()
	
	var results = [RMResult]()
	var currentPage = 1
	

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Rick & Morty"
		
		
		overrideUserInterfaceStyle = .dark
		navigationController?.overrideUserInterfaceStyle = .dark
		navigationController?.setNavigationBarHidden(true, animated: false)
		
		
		setupImageView()
		setupHeaderTitleView()
		setupTableView()
		request(page: currentPage)
	}
	
	
	private func setupHeaderTitleView() {
		
		headerTitleView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(headerTitleView)
		
		
		NSLayoutConstraint.activate([
		
			headerTitleView.widthAnchor.constraint(equalTo: view.widthAnchor),
			headerTitleView.heightAnchor.constraint(equalToConstant: headerTitleView.expectedHeight),
			headerTitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			headerTitleView.topAnchor.constraint(equalTo: view.topAnchor)
		
		])
		
	}
	
	private func setupImageView() {
		
		bgImageView.image = UIImage(named: "rm_bg")
		bgImageView.contentMode = .scaleAspectFill
		bgImageView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(bgImageView)
		
		NSLayoutConstraint.activate([
		
			bgImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
			bgImageView.heightAnchor.constraint(equalTo: view.heightAnchor),
			bgImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			bgImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		
		])
		
	}
	
	private func setupTableView() {
		
		tableView.backgroundColor = nil
		tableView.register(EpisodeCell.self, forCellReuseIdentifier: "EpisodeCell")
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.separatorStyle = .none
		tableView.delegate = self
		tableView.dataSource = self
		view.addSubview(tableView)
		
		
		NSLayoutConstraint.activate([
		
			tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
			tableView.heightAnchor.constraint(equalTo: view.heightAnchor),
			tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		
		])
		
	}
	
	private func request(page: Int) {
		
		let endpoint = "https://rickandmortyapi.com/api/episode/?page=\(page)"
		
		guard let url = URL(string: endpoint)
			else { return }
		
		let request = URLRequest(url: url)
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			
			guard error == nil,
				let data = data,
				let response = try? JSONDecoder().decode(RMResponse.self, from: data)
				else { return }
			
			self.results.append(contentsOf: response.results)
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
			
		}.resume()
		
	}

}



/* * * * * * * * * * * * * * * * * * * * * * * *
 *
 *	TableView Delegate & DataSource
 *
 */
extension ViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return results.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
		let result = results[indexPath.row]
		cell.nameLabel.text = result.name
		cell.episodeLabel.text = result.episode
		return cell
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		guard let cell = tableView.cellForRow(at: indexPath) as? EpisodeCell else { return }
		cell.highlight()
		let detailViewController = DetailViewController()
		detailViewController.result = results[indexPath.row]
		navigationController?.present(detailViewController, animated: true, completion: {
			cell.unhighlight()
		})
		
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		guard results.count - 1 == indexPath.row
			else { return }
		
		currentPage += 1
		request(page: 2)
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return headerTitleView.frame.height
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: headerTitleView.frame.height))
		view.isUserInteractionEnabled = false
		return view
	}
	
	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? EpisodeCell else { return }
		cell.highlight()
	}
	
	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? EpisodeCell else { return }
		cell.unhighlight()
	}
	
}



/* * * * * * * * * * * * * * * * * * * * * * * *
 *
 *	ScrollView Delegate
 *
 */
extension ViewController {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		let adjustedOffset = scrollView.contentOffset.y + scrollView.safeAreaInsets.top
		let maxOffset = headerTitleView.frame.size.height
		guard maxOffset != 0 else { return }
		
		let percent = adjustedOffset / headerTitleView.frame.size.height
		headerTitleView.scale(by: percent)
		
	}
	
}
