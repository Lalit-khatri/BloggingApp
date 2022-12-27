//
//  SignUpViewController.swift
//  Thoughts
//
//  Created by Lalit kumar on 17/11/22.
//

import UIKit

class SignUpViewController: UITabBarController {
    // Header view
    private let headerView  = SignInHeaderView()
    
    // name field
    private let nameField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.keyboardType = .emailAddress
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "Full Name"
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()

    
    // Email field
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "Email Address"
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    // password field
    private let passwordField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "Passwords"
        field.isSecureTextEntry = true
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()

    
    // Sign In button
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
//        button.layer.cornerRadius = 14
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(nameField)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//            if !IAPManager.shared.isPremimum() {
//                let vc  = UINavigationController(rootViewController:
//                    PayWallViewController())
//                self.present(vc, animated: true, completion: nil)
//            }
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/5)
        nameField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width-40, height: 50)
        emailField.frame = CGRect(x: 20, y: nameField.bottom+10, width: view.width-40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width-40, height: 50)
        signUpButton.frame = CGRect(x: 20, y: passwordField.bottom+10, width: view.width-40, height: 50)
        
    }
    
    @objc func didTapSignUpButton() {
        guard let email = emailField.text , !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let name = nameField.text, !name.isEmpty else {
            return
        }
        
        // Create User
        AuthManager.shared.signUp(email: email, password: password) {[weak self] success in
            if success {
                // update database
                let newUser = User(name: name, email: email, profilePictureRef: nil)
                DatabaseManager.shared.insert(user: newUser) { inserted in
                    guard inserted else {
                        return
                    }
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(name, forKey: "name")
                    DispatchQueue.main.async {
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true, completion: nil)
                    }
                }
            } else {
               
                print("Failed to create account ")
            }
            
        }
    }
    
}
