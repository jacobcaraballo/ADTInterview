//
//  CharacterCell.swift
//  ADTInterview
//
//  Created by Jacob Caraballo on 9/8/20.
//  Copyright © 2020 AppsByJ. All rights reserved.
//

import Foundation
import UIKit


class CharacterCell: UITableViewCell {
	
	let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
	
	let characterImageView = UIImageView()
	let speciesLabel = UILabel()
	let nameLabel = UILabel()
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = nil
		contentView.backgroundColor = nil
		selectionStyle = .none
		
		setupImageView()
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
		
	}
	
	private func setupImageView() {
		
		let imageSize: CGFloat = 50
		characterImageView.backgroundColor = UIColor(white: 0.1, alpha: 1)
		characterImageView.translatesAutoresizingMaskIntoConstraints = false
		characterImageView.contentMode = .scaleAspectFill
		characterImageView.clipsToBounds = true
		blurView.contentView.addSubview(characterImageView)
		
		NSLayoutConstraint.activate([
		
			characterImageView.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor),
			characterImageView.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 10),
			characterImageView.widthAnchor.constraint(equalToConstant: imageSize),
			characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor)
		
		])
		
		
		characterImageView.layer.cornerRadius = imageSize / 2
		
	}
	private func setupLabels() {
		
		let labelsContainer = UIView()
		labelsContainer.translatesAutoresizingMaskIntoConstraints = false
		blurView.contentView.addSubview(labelsContainer)
		
		
		let edgePadding: CGFloat = 10
		NSLayoutConstraint.activate([
			
			labelsContainer.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: edgePadding),
			labelsContainer.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -edgePadding),
			labelsContainer.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: edgePadding),
			labelsContainer.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -edgePadding)
			
		])
		
		
		let shadowOpacity: Float = 0.5
		let shadowRadius: CGFloat = 1.5
		let shadowOffset = CGSize(width: 2, height: 2)
		
		
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.text = "Hello, World"
		nameLabel.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
		nameLabel.layer.shadowColor = UIColor.black.cgColor
		nameLabel.layer.shadowRadius = shadowRadius
		nameLabel.layer.shadowOpacity = shadowOpacity
		nameLabel.layer.shadowOffset = shadowOffset
		nameLabel.layer.masksToBounds = false
		nameLabel.sizeToFit()
		nameLabel.text = ""
		
		speciesLabel.translatesAutoresizingMaskIntoConstraints = false
		speciesLabel.text = "Hello, World"
		speciesLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		speciesLabel.layer.shadowColor = UIColor.black.cgColor
		speciesLabel.layer.shadowRadius = shadowRadius
		speciesLabel.layer.shadowOpacity = shadowOpacity
		speciesLabel.layer.shadowOffset = shadowOffset
		speciesLabel.layer.masksToBounds = false
		speciesLabel.sizeToFit()
		speciesLabel.text = ""
		
		
		labelsContainer.addSubview(nameLabel)
		labelsContainer.addSubview(speciesLabel)
		
		NSLayoutConstraint.activate([
			
			nameLabel.widthAnchor.constraint(equalTo: labelsContainer.widthAnchor),
			nameLabel.centerXAnchor.constraint(equalTo: labelsContainer.centerXAnchor),
			nameLabel.topAnchor.constraint(equalTo: labelsContainer.topAnchor),
			
			speciesLabel.widthAnchor.constraint(equalTo: labelsContainer.widthAnchor),
			speciesLabel.centerXAnchor.constraint(equalTo: labelsContainer.centerXAnchor),
			speciesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor)
			
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
	
}

