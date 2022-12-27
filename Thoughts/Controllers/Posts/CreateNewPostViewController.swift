//
//  CreateNewPostViewController.swift
//  Thoughts
//
//  Created by Lalit kumar on 17/11/22.
//

import UIKit

class CreateNewPostViewController: UITabBarController {

    //Title field
    private let titleField: UITextField = {
         let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Enter title.."
        field.autocorrectionType = .no
        field.autocapitalizationType = .words
        field.backgroundColor = .secondarySystemBackground
        field.layer.masksToBounds = true
        return field
    }()
    
    // Image Header
    private let headerImageView: UIImageView = {
        let imageView =  UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()
    
    // TextView for post
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .secondarySystemBackground
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 28)
        return textView
    }()
    
    private var selectedHeaderImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(headerImageView)
        view.addSubview(textView)
        view.addSubview(titleField)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        headerImageView.addGestureRecognizer(tap)
        configureButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleField.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.width-20, height: 50)
        headerImageView.frame = CGRect(x: 10, y: titleField.bottom+5, width: view.width-20, height: 160)
        textView.frame = CGRect(x: 10, y: headerImageView.bottom + 10, width: view.width - 20, height: view.height-310-view.safeAreaInsets.top)
    }
    
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(didTapCancel)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Post",
            style: .done,
            target: self,
            action: #selector(didTapPost)
        )
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapPost() {
        // check data and post
        
        guard let title = titleField.text,
              let body = textView.text,
              let headerImage = selectedHeaderImage,
              let email = UserDefaults.standard.string(forKey: "email"),
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            let alert = UIAlertController(title: "Enter post Details", message: "Please enter a title, Body and select a image to continue.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
             present(alert, animated: true)
            return
        }
        
        // upload header image
        
        let postId = UUID().uuidString
        StorageManager.shared.uploadBlogHeaderImage(
            email: email,
            image: headerImage,
            postId: postId
        ) { updated in
            if !updated {
                print("not uploaded image")
                return
            }
            StorageManager.shared.downloadUrlForPostHeader(email: email, postId: postId) { url in
                guard let headerUrl = url else {
                    print("Failed to doenload url")
                    return
                }
                
                let post = BlogPost(
                    identifier: UUID().uuidString,
                    title: title,
                    timestamp: Date().timeIntervalSince1970,
                    headerImageUrl: headerUrl,
                    text: body
                )
                // Insert post in DB
                DatabaseManager.shared.insert(blogPost: post, email: email) { [weak self] success in
                    if !success {
                        print("Failed to post new blog")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self?.didTapCancel()
                    }
                }
                
            }
        }
    }
    
    @objc private func didTapHeader() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
       present(picker, animated: true)
    }
}

extension CreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            print("something went wrong")
            return
        }
        selectedHeaderImage =  image
        headerImageView.image = image
    }
}
