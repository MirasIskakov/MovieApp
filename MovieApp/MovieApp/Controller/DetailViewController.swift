//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Miras Iskakov on 15.05.2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movieID = 0
    let urlImage = "https://image.tmdb.org/t/p/w500"
    var movieData: DetailsModel?
    
    lazy var scrollMovieDetail: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = true
        
        return scroll
    }()
    
    private lazy var detailImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 30
        return image
    }()
    
    private lazy var detailTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var realeseDateLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var genreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Movie"
        setupLayout()
        apiRequest()
    }
    
    func apiRequest() {
        let session = URLSession(configuration: .default)
        lazy var urlComponent: URLComponents = {
            var component = URLComponents()
            component.scheme = "https"
            component.host = "api.themoviedb.org"
            component.path = "/3/movie/\(movieID)"
            component.queryItems = [
                URLQueryItem(name: "api_key", value: "53f2b8593c9cbda990834e04c51c64e8")
            ]
            return component
        }()
        
        guard let requestUrl = urlComponent.url else { return }
        let task = session.dataTask(with: requestUrl) {
            data, response, error in
            guard let data = data else { return }
            if let movie = try? JSONDecoder().decode(DetailsModel.self, from: data)
            {
                DispatchQueue.main.async {
                    self.movieData = movie
                    self.content()
                }
            }
        }
        task.resume()
    }
    func content() {
        guard let movieData = movieData else { return }
        detailTitle.text = movieData.originalTitle
        realeseDateLabel.text = "Release Data \(movieData.releaseDate ?? "Not announced")"
        let urlString = urlImage + movieData.posterPath!
        let url = URL(string: urlString)
        DispatchQueue.global(qos: .userInteractive).async {
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    self.detailImage.image = UIImage(data: data)
                }
            }
        }
    }

    func setupLayout() {
        lazy var stackReleseView: UIStackView = {
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            return stack
        }()
        
        view.addSubview(stackReleseView)
        view.addSubview(scrollMovieDetail)
        scrollMovieDetail.addSubview(detailImage)
        scrollMovieDetail.addSubview(detailTitle)
        scrollMovieDetail.addSubview(stackReleseView)
        stackReleseView.addSubview(realeseDateLabel)
        stackReleseView.addSubview(genreCollectionView)

        
        
        NSLayoutConstraint.activate([
            scrollMovieDetail.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollMovieDetail.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollMovieDetail.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollMovieDetail.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailImage.topAnchor.constraint(equalTo: scrollMovieDetail.topAnchor),
            detailImage.leadingAnchor.constraint(equalTo: scrollMovieDetail.leadingAnchor, constant: 32),
            detailImage.trailingAnchor.constraint(equalTo: scrollMovieDetail.trailingAnchor, constant: -32),
            detailImage.heightAnchor.constraint(equalToConstant: 424),
            detailTitle.topAnchor.constraint(equalTo: detailImage.bottomAnchor, constant: 17),
            detailTitle.leadingAnchor.constraint(equalTo: scrollMovieDetail.leadingAnchor,constant: 32),
            detailTitle.trailingAnchor.constraint(equalTo: scrollMovieDetail.trailingAnchor, constant: -32),
            stackReleseView.topAnchor.constraint(equalTo: detailTitle.bottomAnchor,constant: 17),
            stackReleseView.leadingAnchor.constraint(equalTo:  scrollMovieDetail.leadingAnchor,constant: 32),
            stackReleseView.trailingAnchor.constraint(equalTo: scrollMovieDetail.trailingAnchor, constant: -32),
            stackReleseView.bottomAnchor.constraint(equalTo: scrollMovieDetail.bottomAnchor, constant: -17),
            detailImage.widthAnchor.constraint(equalToConstant: 309)
        ])
    }
    
   

}


extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieData?.genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        
        return cell
    }
}
