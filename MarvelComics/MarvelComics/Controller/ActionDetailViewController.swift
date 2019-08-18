//
//  ActionDetailViewController.swift
//  MarvelComics
//
//  Created by vikas on 13/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import UIKit
class ActionDetailViewController:UIViewController{
    // MARK: - Outlets
    @IBOutlet weak var blurImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    
    var heroDetail: ActionDetails?
    var detailImage: UIImage?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpArtifact()
    }
    
    // MARK: - Class func
    
    class func instanceFromStoryboard() -> ActionDetailViewController {
        let storyboard = UIStoryboard(name: "ActionDetails", bundle: nil)
        return storyboard.instantiateInitialViewController() as! ActionDetailViewController
    }
    
    // MARK: - Set Up Functions
    
    fileprivate func setUpArtifact() {
        title = heroDetail?.title
        
        /* Image */
        imageView.image = detailImage
        blurImageView.image = detailImage
        addBlur(blurImageView)
        
        /* Labels */
        publishedDateLabel.text = formatDate(from: heroDetail?.dates?.first?.date) ?? "No date available"
        titleLabel.text = heroDetail?.title ?? "No title available"
        if let description = heroDetail?.description, !description.isEmpty {
            descriptionLabel.text = description
        } else {
            descriptionLabel.text = "Description not available"
        }
    }
    
}

// MARK: - Helpers

extension ActionDetailViewController {
    fileprivate func addBlur(_ imageView: UIImageView) {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        effectView.frame = view.bounds
        imageView.addSubview(effectView)
    }
    
    fileprivate func formatDate(from dateString: String?) -> String? {
        guard let dateString = dateString else { return nil }
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = MarvelApiContent.Constants.DateFormat
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        if let date = dateFormatterGet.date(from: dateString) {
            return dateFormatterPrint.string(from: date)
        } else {
            return nil
        }
    }
}
