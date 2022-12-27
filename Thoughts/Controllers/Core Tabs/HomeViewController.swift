//
//  ViewController.swift
//  Thoughts
//
//  Created by Lalit kumar on 16/11/22.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    private let composeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)) , for: .normal)
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostPreviewTableViewCell.self, forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(composeButton)
        composeButton.addTarget(self, action: #selector(didTapCreatePost), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllPosts()
    }

    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        composeButton.frame = CGRect(
            x: view.frame.width - 88,
            y: view.frame.height - 88 - view.safeAreaInsets.bottom ,
            width: 60,
            height: 60
        )
        tableView.frame = view.bounds
    }
   
    
    @objc private func didTapCreatePost() {
        let vc = CreateNewPostViewController()
        vc.title = "Create post"
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
    // tableView
    
    private var posts: [BlogPost] = []
    
    private func fetchAllPosts() {
        DatabaseManager.shared.getAllPost { [weak self] posts in
            self?.posts = posts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as! PostPreviewTableViewCell
        cell.configure(with: .init(title: post.title, imageUrl: post.headerImageUrl) )
        return cell
    }
    
//    heightforrow
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard IAPManager.shared.canViewPost  else {
            let vc = PayWallViewController()
            present(vc, animated: true)
            return
        }
        let vc = ViewPostViewController(post: posts[indexPath.row])
        vc.title = "Post"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

