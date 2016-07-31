//
//  ViewController.swift
//  Reachability
//
//  Created by Emile Décosterd on 31.07.16.
//  Copyright © 2016 Emile Décosterd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var reachabilityController: ReachabilityController! = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewDidAppear(animated: Bool) {
    reachabilityController = ReachabilityController(view: self.view)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

