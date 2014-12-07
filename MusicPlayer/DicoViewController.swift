//
//  DicoViewController.swift
//  MusicPlayer
//
//  Created by Bappel on 07.12.14.
//  Copyright (c) 2014 no.Bappel. All rights reserved.
//

import UIKit

class DicoViewController: UIViewController {

    @IBOutlet weak var discoBlock: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        disco()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func disco(){
    
    
        let options = UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.Repeat
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: options, animations: {
            
            self.discoBlock.backgroundColor = UIColor.blackColor()
            self.discoBlock.backgroundColor = UIColor.whiteColor()
            
            }, completion: nil)
    }
}

