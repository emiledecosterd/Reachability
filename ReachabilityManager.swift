//
//  ReachabilityManager.swift
//  Reachability
//
//  Created by Emile Décosterd on 31.07.16.
//  Copyright © 2016 Emile Décosterd. All rights reserved.
//

import Foundation

// If we use notification
public let kNetworkStatusChangedNotification = "com.ED-automation.networkStatusChanged"


// MARK: Class
// MARK: -
public class ReachabilityManager: Reachable {
  
  // MARK: Properties
  var reachability: AAPLReachability
  public var status: NetworkStatus! = nil // !! First instantiated in "startMonitoring()" !! Do not use before
  
  // Wifi
  public var wifiOnly: Bool = false
  public var isOnWifi: Bool {
    return reachability.currentReachabilityStatus() == ReachableViaWiFi
  }
  
  // If we want to use it as a singleton
  static public var sharedManager = ReachabilityManager()
  
  // If we use the class with delegate pattern
  public var delegate: ReachabilityDelegate?
  
  
  // MARK: Initialisation
  
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
  
  
  // MARK: Monitoring
  
  public func startMonitoring() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ReachabilityManager.reachabilityChanged(_:)), name: kReachabilityChangedNotification, object: nil)
    reachability.startNotifier()
    status = NetworkStatus(networkStatus: reachability.currentReachabilityStatus() as AAPLNetworkStatus)
  }
  
  @objc private func reachabilityChanged(notification: NSNotification){
    reachability = notification.object as! AAPLReachability
    status = NetworkStatus(networkStatus: reachability.currentReachabilityStatus() as AAPLNetworkStatus)
    
    // When new status is .Cellular, dont't issue a notification or a delegate call if wifiOnly is set to false. In fact we still have an internet connection and we don't care if it is not a wifi connection.
    if !wifiOnly {
      switch status! {
      case .Cellular: return
      default: break
      }
    }
    
    // Tell the delegate which is the new network status
    delegate?.reachabilityStatusChanged(status)
    
    // Issue a notification so we can have multiple listeners
    let notification = NSNotification(name: kNetworkStatusChangedNotification, object: nil, userInfo: ["status": status.rawValue])
    NSNotificationCenter.defaultCenter().postNotification(notification)
    
  }
  
}