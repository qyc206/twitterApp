//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Qin Ying Chen on 10/6/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()     // pull tweets for the first time
        // make loadTweet function the target refresh control action
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        // let table view know which refresh control to use
        tableView.refreshControl = myRefreshControl
    }
    
    @objc func loadTweets(){
        // set number of tweets to 20
        numberOfTweet = 20
        
        // load api
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            // clean up array of tweets
            self.tweetArray.removeAll()
            // add tweet to the array of tweets
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            // reload data with new content
            self.tableView.reloadData()
            
            // stop refreshing
            self.myRefreshControl.endRefreshing()
            
        }, failure: { Error in
            print("Could not retrieve tweets!!! AHHHHH")
        })
    }
    
    func loadMoreTweets(){
        // load api
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweet = numberOfTweet + 20  // add 20 more to the current number of tweets
        let myParams = ["count": numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            // clean up array of tweets
            self.tweetArray.removeAll()
            // add tweet to the array of tweets
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            // reload data with new content
            self.tableView.reloadData()
            
        }, failure: { Error in
            print("Could not retrieve tweets!!! AHHHHH")
        })
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        // if user gets close to end of page, load more tweets
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        // when user logs out, set "userLoggedIn" key to false
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        // set name
        cell.userNameLabel.text = user["name"] as? String
        // set content
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        // set image
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    

}
