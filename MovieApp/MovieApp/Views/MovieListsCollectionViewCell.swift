//
//  MovieListsCollectionViewCell.swift
//  MovieApp
//
//  Created by Miras Iskakov on 14.05.2024.
//

import UIKit

class MovieListsCollectionViewCell: UICollectionViewCell {
    
    private lazy var labelML: UILabel = {
        let button = UILabel()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.font = UIFont.preferredFont(forTextStyle: .footnote)
        button.textAlignment = .center
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 11
        button.backgroundColor = .black
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
        contentView.addSubview(labelML)
        contentView.layer.cornerRadius = 11
        
        NSLayoutConstraint.activate([
            labelML.topAnchor.constraint(equalTo: contentView.topAnchor),
            labelML.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labelML.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            labelML.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

extension MovieListsCollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
