//
//  HeroDetailViewController.swift
//  MarvelComics
//
//  Created by vikas on 13/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import UIKit
class HeroDetailViewController:UIViewController{
    
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var comicButton: Button!
    @IBOutlet weak var seriesButton: Button!
    @IBOutlet weak var storiesButton: Button!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var heroImage:UIImage?
    var heroID:Int?
    var heroName:String?
    var heroDescription:String?
    var heroComicCount:Int?
    var heroSeriesCount:Int?
    var heroStoriesCount:Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHero()
    }
    
    class func instanceFromStoryboard() -> HeroDetailViewController{
        let storyboard = UIStoryboard(name: "HeroDetails", bundle: nil)
        return storyboard.instantiateInitialViewController() as! HeroDetailViewController
    }
    
    func setHero(with hero: Hero){
        heroID = hero.id
        heroName = hero.name
        heroDescription = hero.description
        heroComicCount = hero.comics?.available
        heroSeriesCount = hero.series?.available
        heroStoriesCount = hero.stories?.available
        
    }
    
    func setHero(with myHero: MyHero){
        if let imageData = myHero.image{
            heroImage = UIImage(data: imageData)
        }
            heroID = Int(myHero.id)
            heroName = myHero.name
            heroDescription = myHero.about
            heroStoriesCount = Int(myHero.storiesCount)
            heroSeriesCount = Int(myHero.seriesCount)
            heroComicCount = Int(myHero.comicCount)
        }
        
        
        fileprivate func setUpHero(){
            title = heroName
            heroNameLabel.text = heroName
            heroImageView.image = heroImage
            if let description = heroDescription,!description.isEmpty{
                descriptionLabel.text = description
            }else{
                descriptionLabel.text = "Description not available"
            }
            
            
            
            //comic button
            comicButton.isEnabled = heroComicCount ?? 0>0
            comicButton.setTitle("\(heroComicCount ?? 0) COMICS", for: .normal)
            
            
            //series button
            seriesButton.isEnabled = heroSeriesCount ?? 0>0
            seriesButton.setTitle("\(heroSeriesCount ?? 0) SERIES", for: .normal)
            
            // Stories button
            storiesButton.isEnabled = heroStoriesCount ?? 0>0
            storiesButton.setTitle("\(heroStoriesCount ?? 0) STORIES", for: .normal)
            
        }
    
    @IBAction func showComics(_ sender: UIButton) {
        let controller = HeroActionViewController.instanceFromStoryboard()
        controller.heroID = heroID
        controller.heroType = HeroDetailsType.comic
        navigationController?.pushViewController(controller, animated: true)
        
    }
    @IBAction func showSeries(_ sender: UIButton) {
        let controller = HeroActionViewController.instanceFromStoryboard()
        controller.heroID = heroID
        controller.heroType = HeroDetailsType.serie
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func showStories(_ sender: UIButton) {
        
        let controller = HeroActionViewController.instanceFromStoryboard()
        controller.heroID = heroID
        controller.heroType = HeroDetailsType.storie
        navigationController?.pushViewController(controller, animated: true)
    }
}
