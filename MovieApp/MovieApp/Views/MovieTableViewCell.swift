//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by Miras Iskakov on 13.05.2024.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 30
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        movieImage.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(movie: MovieTitle) {
        titleLabel.text = movie.titleLabel
        movieImage.image = movie.image
    }
    
    private func setupLayout() {
        let movieStackView = UIStackView(arrangedSubviews: [movieImage, titleLabel])
        movieStackView.translatesAutoresizingMaskIntoConstraints = false
        movieStackView.axis = .vertical
        movieStackView.spacing = 12
        contentView.addSubview(movieStackView)
        NSLayoutConstraint.activate([
            movieStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            movieStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            movieStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

// MARK: - extension
extension MovieTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
