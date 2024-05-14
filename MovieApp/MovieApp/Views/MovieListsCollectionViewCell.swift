//
//  MovieListsCollectionViewCell.swift
//  MovieApp
//
//  Created by Miras Iskakov on 14.05.2024.
//

import UIKit

class MovieListsCollectionViewCell: UICollectionViewCell {
    
    private lazy var buttonML: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 11
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        
        contentView.addSubview(buttonML)
        
        NSLayoutConstraint.activate([
            buttonML.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            buttonML.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            buttonML.heightAnchor.constraint(equalToConstant: 22),
            buttonML.widthAnchor.constraint(equalToConstant: 74),
        ])
    }
}

extension MovieListsCollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
