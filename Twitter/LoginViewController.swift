//
//  LoginViewController.swift
//  Twitter
//
//  Created by Qin Ying Chen on 10/6/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // perform once page shows up
    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.bool(forKey: "userLoggedIn") == true) {
            // perform segue into home screen if user is already logged in
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let myUrl = "https://api.twitter.com/oauth/request_token"
        
        TwitterAPICaller.client?.login(url: myUrl, success: {
            // when user logs in, create a "userLoggedIn" key and set it to true
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            
            // perform segue into home screen if successful login
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { Error in
            // run this code if log in failed...
            print("could not log in!")
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
