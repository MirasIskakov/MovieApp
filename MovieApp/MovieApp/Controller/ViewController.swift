//
//  ViewController.swift
//  MovieApp
//
//  Created by Miras Iskakov on 13.05.2024.
//

import UIKit
import SnapKit
import CoreData
import Lottie

class ViewController: UIViewController {
    
    var movieData: [Results] = []
    
    private var favoriteMovie: [NSManagedObject] = []
    
    private var labelXPosition: Constraint!
    private var labelYPosition: Constraint!
    
    private lazy var movieLabel: UILabel = {
        let label = UILabel()
        label.text = "MovieDB"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        return label
    }()
    
    private lazy var disappearView: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()
    
    private let themes: [MovieTheme] = [.popular, .upcoming, .nowPlaying, .topRated]
    
    private var currentTheme = MovieTheme.popular
    
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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.allowsMultipleSelection = false
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
    
    var errorAnimation: LottieAnimationView = {
        let animation = LottieAnimationView()
        animation = .init(name: "catinbox")
        animation.animationSpeed = 0.5
        animation.loopMode = .loop
        animation.play()
        return animation
    }()
    
//    MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let index = IndexPath(item: 0, section: 0)
        collectionViewOfTheme.selectItem(at: index, animated: false, scrollPosition: [])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchMoviesForTheme(theme: currentTheme)
    }
    
    private func fetchMoviesForTheme(theme: MovieTheme) {
        NetworkManager.shared.loadMovies(theme: theme) { [weak self] result in
            self?.movieData = result
            self?.tableView.reloadData()
        }
    }
    
    func saveFavorites(movie: Results) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistantContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: context) else { return }
        let favoriteManager = NSManagedObject(entity: entity, insertInto: context)
        favoriteManager.setValue(movie.id, forKey: "movieId")
        favoriteManager.setValue(movie.posterPath, forKey: "posterPath")
        favoriteManager.setValue(movie.title, forKey: "title")
        do {
            try context.save()
        } catch {
            print("error save")
        }
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
    
}

// MARK: - extension CollectionView
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        themes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionViewOfTheme.dequeueReusableCell(withReuseIdentifier: MovieListsCollectionViewCell.reuseIdentifier, for: indexPath) as! MovieListsCollectionViewCell
        cell.changeTitle(title: themes[indexPath.row].title, isSelected: themes[indexPath.row] == currentTheme)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard currentTheme != themes[indexPath.row] else { return }
        currentTheme = themes[indexPath.row]
        collectionViewOfTheme.reloadData()
        fetchMoviesForTheme(theme: currentTheme)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        let result = movieData[indexPath.row]
        cell.conf(title: result.title, posterPath: result.posterPath)
       
        cell.isFavoriteMethod = { [weak self] _ in
            guard let self else { return }
            let isInFavorite = !self.favoriteMovie.filter({ ($0.value(forKeyPath: "movieId") as? Int) ==  result.id}).isEmpty
            cell.tapFavorite(isNotFavorite: !isInFavorite)
            if isInFavorite {
                self.deleteFavorite(movie: result)
            }
            else {
                self.saveFavorite(movie: result)
            }
            loadFavorite()
        }
        
        let isFavorite = !self.favoriteMovie.filter( { $0.value(forKeyPath: "movieId") as? Int == result.id } ).isEmpty
        cell.tapFavorite(isNotFavorite: isFavorite)
        
        return cell
    }
    
//    MARK: - DetailViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMovie = movieData[indexPath.row]
        
        let movieDetailVC = DetailViewController()
        
        movieDetailVC.movieID = selectedMovie.id
        
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
}
