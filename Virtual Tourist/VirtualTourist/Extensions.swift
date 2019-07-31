//
//  Extensions.swift
//  VirtualTourist
//
//  Created by vikas on 29/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{    
    func showAlertMessage(message:String){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title:"Error!",message: message,preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController,animated: true,completion: nil)
        }
    }
}
