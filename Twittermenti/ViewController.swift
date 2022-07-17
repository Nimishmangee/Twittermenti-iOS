//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier: TweetSentimentClassifier = {
        do {
            let config = MLModelConfiguration()
            return try TweetSentimentClassifier(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create TweetSentimentClassifier")
        }
    }()
    
    let swifter=Swifter(consumerKey: "KNOfcg86mhfxzukCE8dyH60W5", consumerSecret: "uwR4WAQDqixctJvrcvfmmGQKp1LJfHZ1hlpJBqupW1vw9Tbctl");

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let prediction = try! sentimentClassifier.prediction(text: "Apple is bad")
//
//        print(prediction.label)
        
        swifter.searchTweet(using: "@Google", lang:"en", count: 100, tweetMode: .extended) { results, searchMetadata in
            
            var tweets=[TweetSentimentClassifierInput]()
            
            for i in 0..<100 {
                if let tweet=results[i]["full_text"].string{
                    let tweetForClassification=TweetSentimentClassifierInput(text: tweet);
                    tweets.append(tweetForClassification)
                }
            }
            do{
                let predictions=try self.sentimentClassifier.predictions(inputs: tweets)
                
                var sentimentScore=0;
                
                for pred in predictions{
                    let sentiment=pred.label
                    
                    if sentiment=="Pos"{
                        sentimentScore+=1;
                    } else if sentiment=="Neg"{
                        sentimentScore-=1;
                    }
                }
                
                print(sentimentScore);
            }
            
            
            catch{
                print("There was an error in prediction, \(error)");
            }
            
            
        } failure: { error in
            print("There was an error with the Twitter API Request \(error)");
        }

    }

    @IBAction func predictPressed(_ sender: Any) {
        
    }
    
}

