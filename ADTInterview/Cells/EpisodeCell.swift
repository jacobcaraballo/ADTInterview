//
//  EpisodeCell.swift
//  ADTInterview
//
//  Created by Jacob Caraballo on 9/8/20.
//  Copyright © 2020 AppsByJ. All rights reserved.
//

import Foundation
import UIKit


class EpisodeCell: UITableViewCell {
	
	let blurView = UIVisualEffectView()
	var blurAnim: UIViewPropertyAnimator!
	
	let nameLabel = UILabel()
	let episodeLabel = UILabel()
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = nil
		contentView.backgroundColor = nil
		selectionStyle = .none
		
		setupBlurView()
		setupLabels()
	}
	
	private func setupBlurView() {
		
		blurView.translatesAutoresizingMaskIntoConstraints = false
		blurView.layer.cornerRadius = 15
		blurView.layer.masksToBounds = true
		contentView.addSubview(blurView)
		
		
		let edgePaddingX: CGFloat = 20
		let edgePaddingY: CGFloat = 10
		NSLayoutConstraint.activate([
		
			blurView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -(edgePaddingX * 2)),
			blurView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -edgePaddingY),
			blurView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			blurView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		
		])
		
		
		// sets the blur radius using an animator
		let blurRadius: CGFloat = 0.5
		blurAnim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
			self.blurView.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
		}
		blurAnim.fractionComplete = blurRadius
		
	}
	
	private func setupLabels() {
		
		let labelsContainer = UIView()
		labelsContainer.translatesAutoresizingMaskIntoConstraints = false
		blurView.contentView.addSubview(labelsContainer)
		
		
		let edgePadding: CGFloat = 10
		NSLayoutConstraint.activate([
		
			labelsContainer.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: edgePadding),
			labelsContainer.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -edgePadding),
			labelsContainer.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: edgePadding),
			labelsContainer.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -edgePadding)
		
		])
		
		
		let shadowOpacity: Float = 0.5
		let shadowRadius: CGFloat = 1.5
		let shadowOffset = CGSize(width: 2, height: 2)
		
		
		episodeLabel.translatesAutoresizingMaskIntoConstraints = false
		episodeLabel.text = "Hello, World"
		episodeLabel.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
		episodeLabel.layer.shadowColor = UIColor.black.cgColor
		episodeLabel.layer.shadowRadius = shadowRadius
		episodeLabel.layer.shadowOpacity = shadowOpacity
		episodeLabel.layer.shadowOffset = shadowOffset
		episodeLabel.layer.masksToBounds = false
		episodeLabel.sizeToFit()
		episodeLabel.text = ""
		
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.text = "Hello, World"
		nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		nameLabel.layer.shadowColor = UIColor.black.cgColor
		nameLabel.layer.shadowRadius = shadowRadius
		nameLabel.layer.shadowOpacity = shadowOpacity
		nameLabel.layer.shadowOffset = shadowOffset
		nameLabel.layer.masksToBounds = false
		nameLabel.sizeToFit()
		nameLabel.text = ""
		
		
		labelsContainer.addSubview(episodeLabel)
		labelsContainer.addSubview(nameLabel)
		
		NSLayoutConstraint.activate([
			
			episodeLabel.widthAnchor.constraint(equalTo: labelsContainer.widthAnchor),
			episodeLabel.centerXAnchor.constraint(equalTo: labelsContainer.centerXAnchor),
			episodeLabel.topAnchor.constraint(equalTo: labelsContainer.topAnchor),
			
			nameLabel.widthAnchor.constraint(equalTo: labelsContainer.widthAnchor),
			nameLabel.centerXAnchor.constraint(equalTo: labelsContainer.centerXAnchor),
			nameLabel.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor)
		
		])
		
		
	}
	
	func highlight() {
		let anim = UIViewPropertyAnimator(duration: 0.25, dampingRatio: 0.5) {
			self.blurView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
		}
		anim.startAnimation()
	}
	
	func unhighlight() {
		let anim = UIViewPropertyAnimator(duration: 0.25, dampingRatio: 0.5) {
			self.blurView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
		}
		anim.startAnimation()
	}
	
	
	deinit {
		// stop blur radius animator
		blurAnim.stopAnimation(true)
		blurAnim.finishAnimation(at: .current)
	}
	
}
