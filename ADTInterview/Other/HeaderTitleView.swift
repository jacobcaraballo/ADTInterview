//
//  HeaderTitleView.swift
//  ADTInterview
//
//  Created by Jacob Caraballo on 9/8/20.
//  Copyright © 2020 AppsByJ. All rights reserved.
//

import Foundation
import UIKit


class HeaderTitleView: UIView {
	
	let container = UIView()
	let titleLabel = UILabel()
	let detailLabel = UILabel()
	
	
	let backgroundView = UIVisualEffectView()
	var backgroundAnim: UIViewPropertyAnimator!
	var bgHeightConstraint: NSLayoutConstraint!
	
	
	let edgePadding: CGFloat = 20
	let contentSpacing: CGFloat = 7
	var safeAreaTopPadding: CGFloat
	var expectedHeight: CGFloat {
		return edgePadding
			+ safeAreaTopPadding
			+ titleLabel.frame.size.height
			+ contentSpacing
			+ detailLabel.frame.size.height
			+ edgePadding
	}
	
	required init?(coder: NSCoder) { return nil }
	
	init(title: String, detail: String, safeAreaTopPadding: CGFloat = 44) {
		self.safeAreaTopPadding = safeAreaTopPadding
		
		super.init(frame: .zero)
		
		
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowRadius = 5.0
		layer.shadowOpacity = 0.7
		layer.shadowOffset = CGSize(width: 0, height: 2)
		
		setupBackgroundView()
		setupContainer()
		setupLabels(title: title, detail: detail)
	}
	
	private func setupBackgroundView() {
		
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		backgroundView.alpha = 0.8
		backgroundView.clipsToBounds = true
		backgroundView.layer.cornerRadius = 10
		backgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
		addSubview(backgroundView)
		
		bgHeightConstraint = backgroundView.heightAnchor.constraint(equalTo: heightAnchor)
		
		NSLayoutConstraint.activate([
			backgroundView.widthAnchor.constraint(equalTo: widthAnchor),
			bgHeightConstraint,
			backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
			backgroundView.topAnchor.constraint(equalTo: topAnchor)
		])
		
		
		let blurRadius: CGFloat = 0.3
		backgroundAnim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
			self.backgroundView.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
		}
		backgroundAnim.fractionComplete = blurRadius
		
		
	}
	
	private func setupContainer() {
		container.translatesAutoresizingMaskIntoConstraints = false
		addSubview(container)
		
		NSLayoutConstraint.activate([
			container.widthAnchor.constraint(equalTo: widthAnchor, constant: -(edgePadding * 2)),
			container.heightAnchor.constraint(equalTo: heightAnchor, constant: -edgePadding),
			container.centerXAnchor.constraint(equalTo: centerXAnchor),
			container.topAnchor.constraint(equalTo: topAnchor, constant: edgePadding + safeAreaTopPadding)
		])
	}
	
	private func setupLabels(title: String, detail: String) {
		
		let shadowOpacity: Float = 0.8
		let shadowRadius: CGFloat = 1.5
		let shadowOffset = CGSize(width: 2, height: 2)
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.text = title
		titleLabel.minimumScaleFactor = 0.5
		titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
		titleLabel.layer.shadowColor = UIColor.black.cgColor
		titleLabel.layer.shadowRadius = shadowRadius
		titleLabel.layer.shadowOpacity = shadowOpacity
		titleLabel.layer.shadowOffset = shadowOffset
		titleLabel.layer.masksToBounds = false
		titleLabel.sizeToFit()
		
		
		detailLabel.translatesAutoresizingMaskIntoConstraints = false
		detailLabel.frame.size.width = UIScreen.main.bounds.width - edgePadding * 2
		detailLabel.text = detail
		detailLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
		detailLabel.numberOfLines = 0
		detailLabel.layer.shadowColor = UIColor.black.cgColor
		detailLabel.layer.shadowRadius = shadowRadius
		detailLabel.layer.shadowOpacity = shadowOpacity
		detailLabel.layer.shadowOffset = shadowOffset
		detailLabel.layer.masksToBounds = false
		detailLabel.sizeToFit()
		
		
		container.addSubview(titleLabel)
		container.addSubview(detailLabel)
		
		
		NSLayoutConstraint.activate([
		
			titleLabel.widthAnchor.constraint(equalTo: container.widthAnchor),
			titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
			titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
			
			detailLabel.widthAnchor.constraint(equalTo: container.widthAnchor),
			detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: contentSpacing),
			detailLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor)
		
		])
		
	}
	
	
	/// Performs scaling and translation of the header view.
	func scale(by percent: CGFloat) {
		
		// scaling
		let minScale: CGFloat = 0.85
		let maxScale: CGFloat = 1.05
		let rawScale = 1 - percent
		let scale = (1.0 - minScale) * rawScale + minScale
		let clampedScale = scale < minScale ? minScale :
							scale > maxScale ? maxScale : scale
		
		
		// y-offset
		let maxYOffset: CGFloat = 100
		let yOffset = percent * maxYOffset
		let clampedYOffset = yOffset < 0 ? 0 : yOffset
		container.transform = CGAffineTransform(scaleX: clampedScale, y: clampedScale)
			.translatedBy(x: 0, y: clampedYOffset)
		container.alpha = (rawScale - 0.25) / (1.0 - 0.25)
		
		
		// height of bg blur
		let maxHeightConstant = UIScreen.main.bounds.height - expectedHeight
		let heightConstant = percent * maxHeightConstant
		let clampedHeightConstant = heightConstant < 0 ? 0 :
			heightConstant > maxHeightConstant ? maxHeightConstant : heightConstant
		bgHeightConstraint.constant = clampedHeightConstant
		layoutIfNeeded()
		
		
		// set bg blur alpha & radius
		backgroundView.alpha = rawScale * 0.7
		backgroundAnim.fractionComplete = rawScale * 0.25
		
	}
	
	deinit {
		// stop blur radius animator
		backgroundAnim.stopAnimation(true)
		backgroundAnim.finishAnimation(at: .current)
	}
	
}
