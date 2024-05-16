//
//  ViewController.swift
//  MovieApp
//
//  Created by Miras Iskakov on 13.05.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var themeData: [String] = ["Popular", "Now Playing", "Upcoming", "Top Rated"]
    var movieData: [MovieModelResult] = []
    
    private lazy var labelTheme: UILabel = {
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
        layout.minimumLineSpacing = 8
        return layout
    }()
    
    lazy var collectionViewOfTheme: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: self.layout)
        collection.dataSource = self
        collection.delegate = self
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
    
//    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        apiRequest()
    }
    
//    MARK: - setupView
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(labelTheme)
        view.addSubview(collectionViewOfTheme)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            labelTheme.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            labelTheme.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            labelTheme.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            labelTheme.heightAnchor.constraint(equalToConstant: 16),
            
            
            collectionViewOfTheme.topAnchor.constraint(equalTo: labelTheme.bottomAnchor),
            collectionViewOfTheme.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionViewOfTheme.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionViewOfTheme.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: collectionViewOfTheme.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

//    MARK: - Network
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

// MARK: - extension CollectionView
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        themeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionViewOfTheme.dequeueReusableCell(withReuseIdentifier: MovieListsCollectionViewCell.reuseIdentifier, for: indexPath) as! MovieListsCollectionViewCell
        cell.labelML.text = themeData[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MovieListsCollectionViewCell
        cell.contentView.backgroundColor = .red
        cell.isSelected = true
        cell.labelML.textColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MovieListsCollectionViewCell {
            cell.contentView.backgroundColor = .systemGray4
            cell.isSelected = false
            cell.labelML.textColor = .black
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 74, height: 22)
    }
}


// MARK: - extension TableView
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
                        cell.config(movie: movie)
                    }
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMovie = movieData[indexPath.row]
        
        let movieDetailVC = DetailViewController()
        
        movieDetailVC.movieID = selectedMovie.id
        
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
