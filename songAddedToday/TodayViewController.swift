//
//  TodayViewController.swift
//  songAddedToday
//
//  Created by Bappel on 07.12.14.
//  Copyright (c) 2014 no.Bappel. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var todayLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        
        let defaults = NSUserDefaults()
        self.todayLabel.text = defaults.objectForKey("songKey") as? String
        
        completionHandler(NCUpdateResult.NewData)
    }
    
}
