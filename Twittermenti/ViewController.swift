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
    
    let tweetCount=100;
    
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
    }

    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweets()
        
    }
    
    func fetchTweets(){
        
        if let searchText=textField.text {
            
            swifter.searchTweet(using: searchText, lang:"en", count: tweetCount, tweetMode: .extended) { results, searchMetadata in
                
                var tweets=[TweetSentimentClassifierInput]()
                
                for i in 0..<self.tweetCount {
                    if let tweet=results[i]["full_text"].string{
                        let tweetForClassification=TweetSentimentClassifierInput(text: tweet);
                        tweets.append(tweetForClassification)
                    }
                }
                self.makePrediction(with: tweets)
                
            } failure: { error in
                print("There was an error with the Twitter API Request \(error)");
            }
        }
        
    }
    
    func makePrediction(with tweets:[TweetSentimentClassifierInput]){
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
            
            updateUI(sentimentScore: sentimentScore)
            
        }
        
        
        catch{
            print("There was an error in prediction, \(error)");
        }
    }
    
    func updateUI(sentimentScore:Int){
        
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😀"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "🙂"
        } else if sentimentScore == 0 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "😕"
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
        
    }
}

