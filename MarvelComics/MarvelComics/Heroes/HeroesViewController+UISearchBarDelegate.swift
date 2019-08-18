//
//  HeroesViewController+UISearchBarDelegate.swift
//  MarvelComics
//
//  Created by vikas on 14/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import UIKit

extension HeroesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5) {
            self.darkView.alpha = 1.0
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5) {
            self.darkView.alpha = 0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let name = searchBar.text {
            searchHero(with: name)
            searchActivated = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        loadHeroes(reset: searchActivated, withIndicator: searchActivated)
        searchActivated = false
    }
}
