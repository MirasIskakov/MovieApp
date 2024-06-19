//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Miras Iskakov on 15.05.2024.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    var movieID = 0
    let urlImage = "https://image.tmdb.org/t/p/w500"
    var movieData: DetailsModel?
    
    lazy var scrollMovieDetail: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = true
        
        return scroll
    }()
    
    private lazy var detailImage: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 30
        return image
    }()
    
    private lazy var detailTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        return label
    }()
    
    lazy var stackReleseView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    lazy var realeseDateLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    lazy var genreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .blue
        collection.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        return collection
    }()
    
    //    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Movie"
        setupLayout()
        apiRequest()
    }
    
    //    MARK: - Network
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

    
    //    MARK: - setupLayout
    func setupLayout() {
        // Добавление подвижного представления и элементов на главное представление
        view.addSubview(stackReleseView)
        view.addSubview(scrollMovieDetail)
        
        // Добавление изображения и заголовка на подвижное представление
        scrollMovieDetail.addSubview(detailImage)
        scrollMovieDetail.addSubview(detailTitle)
        
        // Добавление стека и его элементов на подвижное представление
        scrollMovieDetail.addSubview(stackReleseView)
        stackReleseView.addSubview(realeseDateLabel)
        stackReleseView.addSubview(genreCollectionView)
        
        // Активация ограничений
        scrollMovieDetail.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        detailImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
            make.height.equalTo(424)
            make.width.equalTo(309)
        }
        
        detailTitle.snp.makeConstraints { make in
            make.top.equalTo(detailImage.snp.bottom).offset(17)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().inset(32)
        }
        
        stackReleseView.snp.makeConstraints { make in
            make.top.equalTo(detailTitle.snp.bottom).offset(17)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().offset(-17)
        }
        
        realeseDateLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        genreCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(realeseDateLabel.snp.bottom)
            make.height.equalTo(22)
        }
    }
}


extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieData?.genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as! GenreCollectionViewCell
        guard let genre = movieData?.genres?[indexPath.row].name else { return UICollectionViewCell() }
        cell.label.text = genre
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 22)
    }
}
