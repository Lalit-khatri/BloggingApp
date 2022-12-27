//
//  ProfileViewController.swift
//  Thoughts
//
//  Created by Lalit kumar on 17/11/22.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
     
    
    // profile photo
    
    // Full Name
    
    // Email
    
    // List of posts
    
    private var user: User?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostPreviewTableViewCell.self, forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
     return tableView
    }()
    
    let currentEmail: String
    
    init(currentEmail: String){
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSignOutButton()
        setUpTable()
        fetchPosts()
        title = currentEmail
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpTable(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setUpTableHeader()
        fetchProfileData()
        title = "Profile"
    }
    
    private func setUpTableHeader(profilePhotoRef: String? = nil, name: String? = nil) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        headerView.backgroundColor = .systemBlue
        headerView.isUserInteractionEnabled = true
        headerView.clipsToBounds = true
        tableView.tableHeaderView = headerView
        
        // Profile picture
        let profilePhoto = UIImageView(image: UIImage(systemName: "person.circle"))
        profilePhoto.tintColor = .white
        profilePhoto.contentMode = .scaleAspectFit
        profilePhoto.frame = CGRect(
            x: ((view.width - (view.width/4))/2) ,
            y: (headerView.height-(view.width/4))/2.5,
            width: view.width/4,
            height: view.width/4
        )
        profilePhoto.isUserInteractionEnabled = true
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.width/2
        headerView.addSubview(profilePhoto)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto))
        profilePhoto.addGestureRecognizer(tap)
        
        // name
        
        // Email
        let emailLabel = UILabel(frame: CGRect(x: 20, y: profilePhoto.bottom + 30, width: view.width-40, height: 100))
        emailLabel.text = currentEmail
        emailLabel.textAlignment = .center
        emailLabel.font = .systemFont(ofSize: 25, weight: .bold)
        emailLabel.textColor = .white
        headerView.addSubview(emailLabel)
        
        if let name = name{
            title = name
        }
        
        if let ref = profilePhotoRef {
            StorageManager.shared.downloadUserProfilePicture(path: ref){ url in
                guard let url = url else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let response = response, error == nil, let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        profilePhoto.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
            print(ref)
        }
    }
    
    @objc private func didTapProfilePhoto() {
        
        guard  let myemail = UserDefaults.standard.string(forKey: "email"), currentEmail == myemail else {
          return
        }
      
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func fetchProfileData() {
        DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {
                 return
            }
            
            self?.user = user
            DispatchQueue.main.async {
              self?.setUpTableHeader(profilePhotoRef: user.profilePictureRef, name: user.name)
            }
            
        }
    }
    
    private func setUpSignOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign Out",
            style: .done,
            target: self,
            action: #selector(didTapSignOut))
    }
    
    @objc private func didTapSignOut(){
        let sheet = UIAlertController(title: "Sign Out", message: "Are you sure to sign out", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut {[weak self] success in
                if success {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "name")
                        let signInVc = SignInViewController()
                        signInVc.navigationItem.largeTitleDisplayMode = .always
                        let navVc = UINavigationController(rootViewController: signInVc)
                        navVc.navigationBar.prefersLargeTitles = true
                        navVc.modalPresentationStyle = .fullScreen
                        self?.present(navVc, animated: true, completion: nil)
                    }
                }
            }
            }))
        present(sheet, animated: true)
    }
    
    // tableView
    
    private var posts: [BlogPost] = []
    
    private func fetchPosts() {
        let email = currentEmail
        
        DatabaseManager.shared.getPosts(email: email) { [weak self] posts in
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
        var isOwnedByUser:Bool = false
        
        if let email = UserDefaults.standard.string(forKey: "email") {
            isOwnedByUser = email == currentEmail
        }
        
        if !isOwnedByUser {
            if IAPManager.shared.canViewPost {
                let vc = ViewPostViewController(post: posts[indexPath.row], isOwnedByUser: isOwnedByUser)
                vc.title = "Post"
                navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        else  {
            let vc = ViewPostViewController(post: posts[indexPath.row], isOwnedByUser: isOwnedByUser)
            vc.title = "Post"
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as?UIImage else{
            return
        }
        
        StorageManager.shared.uploadUserProfilePicture(
            email: currentEmail,
            image: image
        ) {[weak self] success in
            guard let strongSelf = self else {
                return
            }
        
            if success {
              // update database
                DatabaseManager.shared.updateProfilePhoto(email: strongSelf.currentEmail){ updated in
                    guard updated else {
                        return
                    }
                
                    DispatchQueue.main.async {
                        strongSelf.fetchProfileData()
                    }
                    
                }
            }
            
        }
    }
}
