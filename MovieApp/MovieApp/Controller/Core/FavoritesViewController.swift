//
//  FavoritesViewController.swift
//  MovieApp
//
//  Created by Miras Iskakov on 12.05.2024.
//

import UIKit
import SnapKit

final class FavoritesViewController: UIViewController {
    
    var movieData: [MovieModel] = []
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.text = "Favorites"
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        return label
    }()
    
    lazy var movieTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(movieTableView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(41)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(41)
        }
        
        movieTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(28)
            make.bottom.trailing.leading.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath)
        return cell
    }
    
    
}
