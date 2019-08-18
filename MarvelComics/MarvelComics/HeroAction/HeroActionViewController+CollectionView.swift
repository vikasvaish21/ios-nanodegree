//
//  HeroActionViewController+CollectionView.swift
//  MarvelComics
//
//  Created by vikas on 13/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import UIKit

extension HeroActionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView = actionDetail.count == 0 ? noResultsLabel : nil
        return actionDetail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionCollectionViewCell.identifier, for: indexPath) as! ActionCollectionViewCell
        cell.prepareCell(with: actionDetail[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterActivityIndicatorView.identifier, for: indexPath) as! FooterActivityIndicatorView
        footerView.activityIndicator.startAnimating()
        return footerView
    }
    
    // MARK: - Infinite Scroll
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == actionDetail.count - MarvelApiContent.Constants.InfiniteScrollLimiar &&
        !loadingAction &&
       actionDetail.count < total
        {
            currentPage += 1
            loadHeroes(withIndicator: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let heroDetails = actionDetail[indexPath.row]
        let heroCell = collectionView.cellForItem(at: indexPath) as! ActionCollectionViewCell
        navToHeroDetails(with: heroDetails, artifactImage: heroCell.imageView.image)
        print("ok")
    }
}

extension HeroActionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8
        let height = view.frame.height / 2
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize / 2, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return total > actionDetail.count ? CGSize(width: collectionView.frame.size.width, height: 50) : CGSize(width: 0, height: 0)
    }
}
