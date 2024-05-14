//
//  ViewController.swift
//  MovieApp
//
//  Created by Miras Iskakov on 13.05.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var labelCollectionCell: UILabel = {
        let label = UILabel()
        label.text = "Theme"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: self.layout)
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(MovieListsCollectionViewCell.self, forCellWithReuseIdentifier: MovieListsCollectionViewCell.reuseIdentifier)
        
        return collection
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 500
        table.separatorStyle = .none
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        return table
    }()
    
    var movieData: [MovieModelResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        apiRequest()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(labelCollectionCell)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            labelCollectionCell.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            labelCollectionCell.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            labelCollectionCell.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            labelCollectionCell.heightAnchor.constraint(equalToConstant: 30),
            
            
            collectionView.topAnchor.constraint(equalTo: labelCollectionCell.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func apiRequest() {
        let session = URLSession(configuration: .default)
        lazy var urlComponent: URLComponents = {
            var component = URLComponents()
            component.scheme = "https"
            component.host = "api.themoviedb.org"
            component.path = "/3/movie/upcoming"
            component.queryItems = [
                URLQueryItem(name: "api_key", value: "53f2b8593c9cbda990834e04c51c64e8")
            ]
            return component
        }()
        guard let requestUrl = urlComponent.url else { return }
        let task = session.dataTask(with: requestUrl) { [weak self]
            data, response, error in
            guard let data = data else { return }
            if let movie = try? JSONDecoder().decode(MovieModel.self, from: data)
            {
                DispatchQueue.main.async {
                    self?.movieData = movie.results
                    self?.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListsCollectionViewCell.reuseIdentifier, for: indexPath) as! MovieListsCollectionViewCell
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as! MovieTableViewCell
        let title = movieData[indexPath.row].title
        let urlImageString = "https://image.tmdb.org/t/p/w500" + movieData[indexPath.row].posterPath
        if let url = URL(string: urlImageString) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url)
                {
                    DispatchQueue.main.async {
                        let movie = MovieTitle(titleLabel: title, image: UIImage(data: data))
                        cell.conf(movie: movie)
                    }
                }
            }
        }
        return cell
    }
}
