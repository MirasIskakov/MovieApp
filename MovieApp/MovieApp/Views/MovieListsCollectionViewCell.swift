//
//  MovieListsCollectionViewCell.swift
//  MovieApp
//
//  Created by Miras Iskakov on 14.05.2024.
//

import UIKit
import SnapKit

class MovieListsCollectionViewCell: UICollectionViewCell {
    
    lazy var labelML: UILabel = {
        let button = UILabel()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.font = UIFont.systemFont(ofSize: 10, weight: .light)
        button.textAlignment = .center
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 11
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUIViews() {
        contentView.addSubview(labelML)
        contentView.layer.cornerRadius = 12
        
        labelML.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    func changeTitle(title: String, isSelected: Bool) {
        labelML.textColor = isSelected ? .white : .black
        contentView.backgroundColor = isSelected ? .red : .systemGray5
        labelML.text = title
    }
}

extension MovieListsCollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
