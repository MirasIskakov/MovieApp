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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let index = IndexPath(item: 0, section: 0)
        collectionView(self.collectionViewOfTheme, didSelectItemAt: index)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let index = IndexPath(item: 0, section: 0)
        collectionViewOfTheme.selectItem(at: index, animated: false, scrollPosition: [])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let index = IndexPath()
        collectionViewOfTheme.deselectItem(at: index, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let index = IndexPath()
        collectionViewOfTheme.deselectItem(at: index, animated: false)
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
    
    let session = URLSession(configuration: .default)
    
    lazy var urlComponent: URLComponents = {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.themoviedb.org"
        component.queryItems = [
            URLQueryItem(name: "api_key", value: "53f2b8593c9cbda990834e04c51c64e8")
        ]
        return component
    }()
    
    func apiRequests(_ path: String) {
        switch path {
        case "Popular":
            getPopular()
        case "Now Playing":
            getNowPlaying()
        case "Upcoming":
            getUpcoming()
        case "Top Rated":
            getTopRated()
        default:
            print("Error")
        }
    }
    
    func getPopular() {
        self.urlComponent.path = "/3/movie/popular"
        guard let requestUrl = urlComponent.url else { return }

        self.session.dataTask(with: requestUrl) { data, response, error in
            DispatchQueue.main.async(flags: .barrier) { [self] in
                guard let data = data, error == nil else {
                    print(data ?? "")
                    return
                }
                do {
                    let response = try JSONDecoder().decode(PopularModel.self, from: data)
                    self.movieData = response.results
                    self.tableView.reloadData()
                    return
                } catch {
                    return print(error)
                }
            }
        }.resume()
    }
    
    func getNowPlaying() {
        self.urlComponent.path = "/3/movie/now_playing"

        guard let requestUrl = self.urlComponent.url else { return }

        session.dataTask(with: requestUrl) { data, response, error in
            DispatchQueue.main.async(flags: .barrier) { [self] in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let response = try JSONDecoder().decode(MovieModel.self, from: data)
                    self.movieData = response.results
                    self.tableView.reloadData()
                    return
                } catch {
                    return print(error)
                }
            }
        }.resume()
    }
    
    func getUpcoming() {
        self.urlComponent.path = "/3/movie/upcoming"

        guard let requestUrl = self.urlComponent.url else { return }

        session.dataTask(with: requestUrl) { data, response, error in
            DispatchQueue.main.async(flags: .barrier) { [self] in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let response = try JSONDecoder().decode(MovieModel.self, from: data)
                    self.movieData = response.results
                    self.tableView.reloadData()
                    return
                } catch {
                    return print(error)
                }
            }
        }.resume()
    }
    
    func getTopRated() {
        self.urlComponent.path = "/3/movie/top_rated"

        guard let requestUrl = self.urlComponent.url else { return }

        session.dataTask(with: requestUrl) { data, response, error in
            DispatchQueue.main.async(flags: .barrier) { [self] in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let response = try JSONDecoder().decode(TopRatedModel.self, from: data)
                    self.movieData = response.results
                    self.tableView.reloadData()
                    return
                } catch {
                    return print(error)
                }
            }
        }.resume()
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
        apiRequests(cell.labelML.text ?? "")
        cell.contentView.backgroundColor = .red
        cell.isSelected = true
        cell.labelML.textColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MovieListsCollectionViewCell
        cell.contentView.backgroundColor = .systemGray4
        cell.isSelected = false
        cell.labelML.textColor = .black
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
