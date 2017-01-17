/*
 * Copyright (c) 2016 Emile Décosterd
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

/// If we use notifications, this is the identifier for changes in the network status.
let kNetworkStatusChangedNotification = "com.ED-automation.networkStatusChanged"


// MARK: Class
// MARK: -
/** Class that keeps track of Reachability changes and notifies other classes of these changes. Can be used
 *  as a singleton
 *  with notifications: issues a notification whenever there is a change in the device's reachability
 *  with the delegate pattern. The delegate property has to be set.
 */
class ReachabilityManager {
  
  // MARK: Properties
  private var reachability: AAPLReachability
  
  /**
   * The current network status.
   * - Warning: First instantiated in `startMonitoring()`. Do not use before.
  */
  var status: NetworkStatus! = nil
  
  // Wifi
  /// If we want to be notified if the device is still connected to internet but not on wifi anymore.
  var wifiOnly: Bool = false
  /// Quickly know at any time if we are connected to a wifi network.
  var isOnWifi: Bool {
    return reachability.currentReachabilityStatus() == ReachableViaWiFi
  }
  
  /// If we want to use it as a singleton
  static var sharedManager = ReachabilityManager()
  
  /// If we use the class with delegate pattern
  var delegate: ReachabilityDelegate?
  
  
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
  
  /// Start monitoring the device's reachability. Launches all the observers.
  func startMonitoring() {
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