//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let swifter=Swifter(consumerKey: "KNOfcg86mhfxzukCE8dyH60W5", consumerSecret: "uwR4WAQDqixctJvrcvfmmGQKp1LJfHZ1hlpJBqupW1vw9Tbctl");

    override func viewDidLoad() {
        super.viewDidLoad()
        swifter.searchTweet(using: "@Apple", lang:"en", count: 100) { results, searchMetadata in
            print(results);
        } failure: { error in
            print("There was an error with the Twitter API Request \(error)");
        }

    }

    @IBAction func predictPressed(_ sender: Any) {
        
        
    }
    
}

