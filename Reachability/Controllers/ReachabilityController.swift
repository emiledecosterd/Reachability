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

import UIKit


// MARK: Base class
// MARK: -
///A class that takes care of everything related to the internet reachability
final class ReachabilityController {
  
  
  // MARK: Properties
  
  //Model
  fileprivate var reachabilityManager: ReachabilityManager
  fileprivate var banner: ReachabilityBanner! = nil{ // Created at initialisation
    didSet{
      showBanner(3)
    }
  }
  
  // Views
  fileprivate unowned var view: UIView
  fileprivate let bannerView: BannerView
  
  // Helpers
  fileprivate var bannerWidth: CGFloat {
    return UIScreen.main.bounds.size.width
  }
  fileprivate var bannerHeight = CGFloat(44)
  
  
  // MARK: Initialisation
  /**
   * Instanciates a `ReachabilityController`.
   *
   * - Parameter view: The view in which to show a banner view when reachability changes. The banner will be displayed on the top of this view.
  */
  init(view: UIView){
    // Setup views
    self.view = view
    let bannerViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0)
    bannerView = BannerView(frame: bannerViewFrame)
    
    // Setup manager
    reachabilityManager = ReachabilityManager()
    reachabilityManager.delegate = self
    reachabilityManager.startMonitoring()
    
    banner = ReachabilityBanner(status: reachabilityManager.status)
    if banner.status != .wifi {
      showBanner(3)
    }
    
    // Respond to orientation changes
    NotificationCenter.default.addObserver(self, selector: #selector(ReachabilityController.orientationChanged(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  
  /**
   * Instanciates a `ReachabilityController`.
   *
   * - Parameter view: The view in which to show a banner view when reachability changes. The banner will be displayed on the top of this view.
   * - Parameter wifiOnly: If we want to be informed when we use cellular connection instead of wifi.
   */
  convenience init(view: UIView, wifiOnly: Bool){
    self.init(view:view)
    reachabilityManager.wifiOnly = true
  }
  
  /**
   * Instanciates a `ReachabilityController`.
   *
   * - Parameter view: The view in which to show a banner view when reachability changes. The banner will be displayed on the top of this view.
   * - Parameter statusBar: If the view contains the status bar, set `statusBar` to `true`.
   */
  convenience init(view: UIView, statusBar: Bool){
    self.init(view: view)
    if statusBar {
      bannerHeight = CGFloat(64)
    }
  }
  
  /**
   * Instanciates a `ReachabilityController`.
   *
   * - Parameter view: The view in which to show a banner view when reachability changes. The banner will be displayed on the top of this view.
   * - Parameter wifiOnly: If we want to be informed when we use cellular connection instead of wifi.
   * - Parameter statusBar: If the view contains the status bar, set `statusBar` to `true`.
   */
  convenience init(view: UIView, wifiOnly: Bool, statusBar: Bool){
    self.init(view: view, wifiOnly: wifiOnly)
    if statusBar{
      bannerHeight = CGFloat(64)
    }
  }
  
  deinit{
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  
  
  // MARK: Show and hide banner depending on reachability changes
  
  fileprivate func showBanner(_ duration: TimeInterval){
    
    // Show the view with animation
    bannerView.setupView(banner)
    view.addSubview(bannerView)
    
    UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.9,
                               initialSpringVelocity: 1,
                               options: [.allowUserInteraction, .beginFromCurrentState],
                               animations: {
                                self.bannerView.changeFrame(CGRect(x: 0, y: 0, width: self.bannerWidth, height: self.bannerHeight))
      }, completion: { (done) in
        // Hide it after 2 sec
        Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(ReachabilityController.timerFinished(_:)), userInfo: true, repeats: false)
    })
    
    
  }
  
  @objc fileprivate func timerFinished(_ timer: Timer){
    timer.invalidate()
    hideBanner(true)
  }
  
  fileprivate func hideBanner(_ animated: Bool){
    if animated {
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: [.allowUserInteraction, .beginFromCurrentState], animations: { 
        self.bannerView.changeFrame(CGRect(x: 0, y: 0, width: self.bannerWidth, height: 0))
        }, completion: { (ok) in
          self.bannerView.removeFromSuperview()
      })
    }else{
      bannerView.removeFromSuperview()
    }
  }
  
  @objc fileprivate func orientationChanged(_ notification: Notification){
    self.view.layoutIfNeeded()
  }
  
}

// MARK: - ReachabilityDelegate
// MARK: -
/// An extension of `ReachabilityController` to conform to `ReachabilityManager`'s delegate protocol
extension ReachabilityController: ReachabilityDelegate {
  func reachabilityStatusChanged(_ status: NetworkStatus) {
    banner = ReachabilityBanner(status: status)
  }
}
