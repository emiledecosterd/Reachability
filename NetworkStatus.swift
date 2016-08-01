//
//  NetworkStatus.swift
//  Reachability
//
//  Created by Emile Décosterd on 31.07.16.
//  Copyright © 2016 Emile Décosterd. All rights reserved.
//

import Foundation

public enum NetworkStatus: Int {
  
  case NotReachable
  case Wifi
  case Cellular
  
  init(networkStatus: AAPLNetworkStatus){
    switch networkStatus.rawValue {
    case 0: self = .NotReachable
    case 1: self = .Wifi
    case 2: self = .Cellular
    default: self = .NotReachable
    }
  }
    
}