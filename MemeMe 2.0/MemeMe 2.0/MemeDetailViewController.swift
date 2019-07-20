//
//  MemeDetailViewController.swift
//  MemeMe 2.0
//
//  Created by vikas on 29/06/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import UIKit
class MemeDetailViewController: UIViewController
{
    var Meme: Meme!
    @IBOutlet weak var imageViewer: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageViewer!.image = Meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
