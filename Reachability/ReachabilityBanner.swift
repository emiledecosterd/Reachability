//
//  ReachabilityBanner.swift
//  Reachability
//
//  Created by Emile Décosterd on 31.07.16.
//  Copyright © 2016 Emile Décosterd. All rights reserved.
//

import UIKit

class ReachabilityBanner {
  
  var status: NetworkStatus
  
  var color: UIColor {
    switch status {
    case .NotReachable: return UIColor.redColor()
    case .Cellular: return UIColor.orangeColor()
    case .Wifi: return UIColor.greenColor()
    }
  }
  
  var message: String {
    switch status {
    case .NotReachable: return "No internet connection!".localized
    case .Cellular: return "Cellular connection".localized
    case .Wifi: return "Wifi connection".localized
    }
  }
  
  init(status: NetworkStatus){
    self.status = status
  }
  
}

