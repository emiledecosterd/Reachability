//
//  ReachabilityManager.swift
//  Reachability
//
//  Created by Emile Décosterd on 31.07.16.
//  Copyright © 2016 Emile Décosterd. All rights reserved.
//

import Foundation

// If we use notification
let kNetworkStatusChangedNotification = "com.ED-automation.networkStatusChanged"

public class ReachabilityManager: Reachable {
  
  var reachability: AAPLReachability
  
  public var wifiOnly: Bool = false
  public var isOnWifi: Bool {
    return reachability.currentReachabilityStatus() == ReachableViaWiFi
  }
  
  // If we want to use it as a singleton
  static public var sharedManager = ReachabilityManager()
  
  // If we use the class with delegate pattern
  public var delegate: ReachabilityDelegate?
  
  init(){
    reachability = AAPLReachability.reachabilityForInternetConnection()
  }
  
  convenience init(wifiOnly: Bool){
    self.init()
    self.wifiOnly = wifiOnly
  }
  
  deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self, name: kReachabilityChangedNotification, object: nil)
  }
  
  public func startMonitoring() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ReachabilityManager.reachabilityChanged(_:)), name: kReachabilityChangedNotification, object: nil)
    reachability.startNotifier()
  }
  
  @objc private func reachabilityChanged(notification: NSNotification){
    reachability = notification.object as! AAPLReachability
    let networkStatus = NetworkStatus(networkStatus: reachability.currentReachabilityStatus() as AAPLNetworkStatus)
    
    // Tell the delegate which is the new network status
    delegate?.reachabilityStatusChanged(networkStatus)
    
    // Issue a notification so we can have multiple listeners
    let notification = NSNotification(name: kNetworkStatusChangedNotification, object: nil, userInfo: ["status": networkStatus.rawValue])
    NSNotificationCenter.defaultCenter().postNotification(notification)
    
  }
  
}