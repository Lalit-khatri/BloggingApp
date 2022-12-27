//
//  PayWallDescriptionView.swift
//  Thoughts
//
//  Created by Lalit kumar on 22/12/22.
//

import UIKit

class PayWallDescriptionView: UIView {

    private let descriptiorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.numberOfLines = 0
        label.text = "Join Thoughts Premium to read unlimited articles and browse thousands of posts."
        return label
    }()
    
    private let PriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 0
        label.text = "$4.99 / month"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(PriceLabel)
        addSubview(descriptiorLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        descriptiorLabel.frame = CGRect(
            x: 20,
            y: 0,
            width: width-40,
            height: height/2
        )
        
        PriceLabel.frame = CGRect(
            x: 20,
            y: height/2,
            width: width-40,
            height: height/2
        )
    }
}
