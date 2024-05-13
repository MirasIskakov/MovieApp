//
//  ViewController.swift
//  MovieApp
//
//  Created by Miras Iskakov on 13.05.2024.
//

import UIKit

class ViewController: UIViewController {
    
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
        view.backgroundColor = .systemCyan
        view.addSubview(tableView)
        let topTableViewConstraint = tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottomTableViewConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let leftTableViewConstraint = tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        let rightTableViewConstraint = tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        
        topTableViewConstraint.isActive = true
        bottomTableViewConstraint.isActive = true
        leftTableViewConstraint.isActive = true
        rightTableViewConstraint.isActive = true
        apiRequest()
    }
    
//    func setupViews() {
//        view.addSubview(tableView)
//    }
//    
//    func setupConstraints() {
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//    }
    
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
        let task = session.dataTask(with: requestUrl) {
            data, response, error in
            guard let data = data else { return }
            if let movie = try? JSONDecoder().decode(MovieModel.self, from: data)
            {
                DispatchQueue.main.async {
                    self.movieData = movie.results
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
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
