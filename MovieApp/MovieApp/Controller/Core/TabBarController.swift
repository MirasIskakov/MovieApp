//
//  TabBarController.swift
//  MovieApp
//
//  Created by Miras Iskakov on 12.05.2024.
//

import UIKit

 class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabs()
    }
    
    private func setupTabs() {
        let homeVC = ViewController()
        let favoritesVC = FavoritesViewController()
        let watchListVC = WatchListViewController()
        let findVC = FindViewController()
        let profileVC = ProfileViewController()
        
//        homeVC.navigationItem.largeTitleDisplayMode = .automatic
//        favoritesVC.navigationItem.largeTitleDisplayMode = .automatic
//        watchListVC.navigationItem.largeTitleDisplayMode = .automatic
//        findVC.navigationItem.largeTitleDisplayMode = .automatic
//        profileVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let navHome = UINavigationController(rootViewController: homeVC)
        let navFavorites = UINavigationController(rootViewController: favoritesVC)
        let navWatchList = UINavigationController(rootViewController: watchListVC)
        let navFind = UINavigationController(rootViewController: findVC)
        let navProfile = UINavigationController(rootViewController: profileVC)
        
        navHome.tabBarItem = UITabBarItem(title: "MovieDB", image: UIImage(systemName: "house"), tag: 1)
        navFavorites.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 2)
        navWatchList.tabBarItem = UITabBarItem(title: "Watch List", image: UIImage(systemName: "eyes"), tag: 3)
        navFind.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 4)
        navProfile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 5)
        
//        for nav in [homeVC, navFavorites, navWatchList, navFind, navProfile] {
//            nav.navigationBar.prefersLargeTitles = true
//        }
        
        setViewControllers(
            [navHome, navFavorites, navWatchList, navFind, navProfile],
            animated: false
        )
    }
}

