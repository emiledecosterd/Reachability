//
//  ReachabilityManager.swift
//  Reachability
//
//  Created by Emile Décosterd on 31.07.16.
//  Copyright © 2016 Emile Décosterd. All rights reserved.
//

import Foundation

class ReachabilityManager: Reachable {
  
  var reachability: AAPLReachability
  var wifiOnly: Bool = false
  
  // If we want to use it as a singleton
  static var sharedManager = ReachabilityManager()
  
  // If we use the class with delegate pattern
  var delegate: ReachabilityDelegate?
  
  // If we use the notifications
  let kNetworkStatusChangedNotification = "com.ED-automation.networkStatusChanged"
  
  init(){
    reachability = AAPLReachability.reachabilityForInternetConnection()
  }
  
  deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self, name: kReachabilityChangedNotification, object: nil)
  }
  
  func startMonitoring() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ReachabilityManager.reachabilityChanged(_:)), name: kReachabilityChangedNotification, object: nil)
    reachability.startNotifier()
  }
  
  @objc func reachabilityChanged(notification: NSNotification){
    reachability = notification.object as! AAPLReachability
    let networkStatus = NetworkStatus(networkStatus: reachability.currentReachabilityStatus() as AAPLNetworkStatus)
    
    // Tell the delegate which is the new network status
    delegate?.reachabilityStatusChanged(networkStatus)
    
    // Issue a notification so we can have multiple listeners
    let notification = NSNotification(name: kNetworkStatusChangedNotification, object: nil, userInfo: ["status": networkStatus.rawValue])
    NSNotificationCenter.defaultCenter().postNotification(notification)
    
  }
  
}

extension ReachabilityManager {
  var isOnWifi: Bool {
    return reachability.currentReachabilityStatus() == ReachableViaWiFi
  }
}