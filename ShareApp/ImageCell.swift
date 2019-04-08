//
//  ImageCell.swift
//  ShareApp
//
//  Created by Dominik Rygiel on 02/04/2019.
//  Copyright © 2019 Dominik Rygiel. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    func update(with image: UIImage) {
        addSubview(imageView)
        imageView.image = image
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}
