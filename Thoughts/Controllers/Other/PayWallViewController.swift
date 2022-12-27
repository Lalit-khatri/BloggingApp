//
//  PayWallViewController.swift
//  Thoughts
//
//  Created by Lalit kumar on 22/12/22.
//

import UIKit

class PayWallViewController: UIViewController {
    // close button and /Title
    
    // Header Image
    private let headerView = PayWallHeaderView()
    
    // pricing and product Info
    private let heroView = PayWallDescriptionView()
    
    // CTA buttons
    private let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Subscribe", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let restoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Restore Purchases", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // terms and service
    private let termsView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 14)
        textView.textAlignment = .center
        textView.textColor = .secondaryLabel
        textView.text = "This is an auto-renewable Subscription. It will charged to your itunes account before each pay period. You can cancel anytime by going into your setting > Subscriptions. Restore purchases if previously subscribed"
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         title = "Thoughts Premium"
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(buyButton)
        view.addSubview(restoreButton)
        view.addSubview(termsView)
        view.addSubview(heroView)
        setUpCloseButton()
        setUpButtons()
    }
    
    private func setUpCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpButtons() {
        buyButton.addTarget(self, action: #selector(didTapSubscribeButton), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(didTapRestoreButton), for: .touchUpInside)
    }
    
    @objc private func didTapSubscribeButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapRestoreButton() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.height/3.2
        )
        termsView.frame = CGRect(
            x: 10,
            y: view.height - 100,
            width: view.width-20,
            height: 100
        )

        restoreButton.frame = CGRect(
            x: 25,
            y: termsView.top - 70,
            width: view.width-50,
            height: 50
        )
        
        buyButton.frame = CGRect(
            x: 25,
            y: restoreButton.top - 70,
            width: view.width-50,
            height: 50
        )
        
        heroView.frame = CGRect(
            x: 0,
            y: headerView.bottom,
            width: view.width,
            height: buyButton.top - view.safeAreaInsets.top - headerView.height
        )
    }
    
  
}
