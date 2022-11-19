//
//  AppFullscreenController.swift
//  AppStoreJSONAPIs
//
//  Created by Rustam Chergizbiev on 11/7/22.
//

import UIKit

class AppFullscreenController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var dismissHandler: (() -> Void)?
	var todayItem: TodayItem?
	
	var floatingContainerView = UIView()
	
	let tableView = UITableView(frame: .zero, style: .plain)
	
	let statusBarHeight: CGFloat = {
		// Чтобы снизу был отступ. Из-за депрекейта. Жесть.
		let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
		let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? .zero
		return height
	}()
	
	let closeButton: UIButton = {
		let button = UIButton(type: .close)
		return button
	}()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.clipsToBounds = true
		
		view.addSubview(tableView)
		tableView.fillSuperview()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		tableView.contentInsetAdjustmentBehavior = .never
		tableView.contentInset = .init(top: 0, left: 0, bottom: statusBarHeight, right: 0)
		
		setupCloseButton()
		setupFloatingControls()
	}
	
	
	fileprivate func setupFloatingControls() {
		let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
		floatingContainerView.addSubview(blurVisualEffectView)
		blurVisualEffectView.fillSuperview()
		
		floatingContainerView.layer.cornerRadius = 16
		floatingContainerView.clipsToBounds = true
		
		view.addSubview(floatingContainerView)
		floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: -2 * statusBarHeight, right: 16), size: .init(width: 0, height: 90))
		
		// add our subviews
		let imageView = UIImageView(cornerRadius: 8)
		imageView.image = todayItem?.image
		imageView.constrainHeight(constant: 64)
		imageView.constrainWidth(constant: 64)
		
		let getButton = UIButton(title: "GET")
		getButton.setTitleColor(.white, for: .normal)
		getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
		getButton.backgroundColor = .darkGray
		getButton.layer.cornerRadius = 16
		getButton.constrainHeight(constant: 32)
		getButton.constrainWidth(constant: 80)
		
		let stackView = UIStackView(arrangedSubviews: [
			imageView,
			VerticalStackView(arrangedSubviews: [
				UILabel(text: todayItem?.category.capitalized ?? "", font: .boldSystemFont(ofSize: 18)),
				UILabel(text: todayItem?.title.capitalized ?? "", font: .systemFont(ofSize: 16), numberOfLines: 1)
			], spacing: 4),
			getButton
		], customSpacing: 16)
		floatingContainerView.addSubview(stackView)
		stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
		stackView.alignment = .center
	}
	
	
	fileprivate func setupCloseButton() {
		view.addSubview(closeButton)
		closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
		closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 48, left: 0, bottom: 0, right: 16), size: .init(width: 32, height: 32))
	}
	
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y < 0 {
			scrollView.isScrollEnabled = false
			scrollView.isScrollEnabled = true
		}
		
		let transform = scrollView.contentOffset.y > 100 ? CGAffineTransform(translationX: 0, y: -3 * self.statusBarHeight) : .identity
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
			self.floatingContainerView.transform = transform
		}
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.item == 0 {
			let headerCell = AppFullscreenHeaderCell()
			headerCell.todayCell.todayItem = todayItem
			headerCell.todayCell.layer.cornerRadius = 0
			headerCell.clipsToBounds = true
			headerCell.backgroundView = nil
			return headerCell
		}
		return AppFullscreenDescriptionCell()
	}
	
	
	@objc func handleDismiss(button: UIButton) {
		button.isHidden = true
		dismissHandler?()
	}
	
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return TodayController.cellSize
		}
		return UITableView.automaticDimension
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
}
