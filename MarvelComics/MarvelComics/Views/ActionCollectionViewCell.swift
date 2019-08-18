//
//  ActionCollectionViewCell.swift
//  MarvelComics
//
//  Created by vikas on 13/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import UIKit

class ActionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    
    static let identifier = "ActionCollectionViewCellID"
    
    override var isHighlighted: Bool {
        didSet {
            self.layer.opacity = isHighlighted ? 0.5 : 1
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        super.prepareForReuse()
    }
    
    func prepareCell(with Details: ActionDetails) {
        titleLabel.text = Details.title
        imageView.image = nil
        
        activityIndicator.startAnimating()
        /* Download the image or recover from the cache */
        MarvelAPIManager.sharedInstance.downloadThumbnail(from: Details.thumbnail?.portraitUrl) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    self.imageView.image = UIImage(named: "imageNotFound")
                case .success(let uiImage):
                    self.imageView.image = uiImage
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
