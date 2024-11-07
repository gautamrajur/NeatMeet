//
//  ShowPostViewController.swift
//  NeetMeetPostPage
//
//  Created by Gautam Raju on 11/3/24.
//

import UIKit

class ShowPostViewController: UIViewController {

    var showPost = ShowPostView()
    
    override func loadView() {
        view = showPost
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
