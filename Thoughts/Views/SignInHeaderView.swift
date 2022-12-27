//
//  SignInHeaderView.swift
//  Thoughts
//
//  Created by Lalit kumar on 22/12/22.
//

import UIKit

class SignInHeaderView: UIView {

    private let logo: UIImageView = {
        let image = UIImageView(image: UIImage(named: ""))
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .systemPink
        return image
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
//        label.textColor = .white
        label.text = "Explore millions of articles!"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(title)
        addSubview(logo)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not using story board")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size: CGFloat = width/4
        logo.frame = CGRect(x: (width-size)/2, y: 10, width: size, height: size)
        title.frame = CGRect(x: 20, y: logo.bottom+10, width: width-40, height: height-size-30)
    }
}
