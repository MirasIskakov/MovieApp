//
//  FavoritesViewController.swift
//  MovieApp
//
//  Created by Miras Iskakov on 12.05.2024.
//

import UIKit
import CoreData
import SnapKit

final class FavoritesViewController: UIViewController {
    
    var movieData: [NSManagedObject] = []
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.text = "Favorites"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        return label
    }()
    
    lazy var movieTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 500
        table.separatorStyle = .none
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        return table
    }()

    // MARK: - lifeСycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uploadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
}

//MARK: - setupUI
extension FavoritesViewController {
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

// MARK: - uploadData
extension FavoritesViewController {
    func uploadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistantContainer.viewContext
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
        do {
            movieData = try context.fetch(fetch)
            movieTableView.reloadData()
        } catch let error as NSError {
            print(error)
        }
    }
}

// MARK: - Delegate, DataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as! MovieTableViewCell
        let movie = movieData[indexPath.row]
        let posterPath = movie.value(forKeyPath: "posterPath") as? String
        let title = movie.value(forKeyPath: "title") as? String
        
        cell.conf(title: title ?? "", posterPath: posterPath ?? "")
        
        return cell
    }
    
    
}
