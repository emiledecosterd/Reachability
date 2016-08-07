//
//  ReachabilityController.swift
//  Reachability
//
//  Created by Emile Décosterd on 31.07.16.
//  Copyright © 2016 Emile Décosterd. All rights reserved.
//

import UIKit


// MARK: Base class
// MARK: -
public final class ReachabilityController {
  
  
  // MARK: Properties
  
  //Model
  private var reachabilityManager: ReachabilityManager
  private var banner: ReachabilityBanner! = nil{ // Created at initialisation
    didSet{
      print("Show banner should be executed")
      showBanner(3)
    }
  }
  
  // Views
  private unowned var view: UIView
  private let bannerView: BannerView
  
  // Helpers
  private var bannerWidth: CGFloat {
    return UIScreen.mainScreen().bounds.size.width
  }
  private var bannerHeight = CGFloat(44)
  
  
  // MARK: Initialisation
  /**
   * Instanciates a `ReachabilityController`.
   *
   * - Parameter view: The view in which to show a banner view when reachability changes. The banner will be displayed on the top of this view.
  */
  public init(view: UIView){
    // Setup views
    self.view = view
    let bannerViewFrame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 0)
    bannerView = BannerView(frame: bannerViewFrame)
    
    // Setup manager
    reachabilityManager = ReachabilityManager()
    reachabilityManager.delegate = self
    reachabilityManager.startMonitoring()
    
    banner = ReachabilityBanner(status: reachabilityManager.status)
    if banner.status != .Wifi {
      showBanner(3)
    }
    
    // Respond to orientation changes
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ReachabilityController.orientationChanged(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil)
  }
  
  /**
   * Instanciates a `ReachabilityController`.
   *
   * - Parameter view: The view in which to show a banner view when reachability changes. The banner will be displayed on the top of this view.
   * - Parameter wifiOnly: If we want to be informed when we use cellular connection instead of wifi.
   */
  public convenience init(view: UIView, wifiOnly: Bool){
    self.init(view:view)
    reachabilityManager.wifiOnly = true
  }
  
  /**
   * Instanciates a `ReachabilityController`.
   *
   * - Parameter view: The view in which to show a banner view when reachability changes. The banner will be displayed on the top of this view.
   * - Parameter statusBar: If the view contains the status bar, set `statusBar` to `true`.
   */
  public convenience init(view: UIView, statusBar: Bool){
    self.init(view: view)
    if statusBar {
      bannerHeight = CGFloat(64)
    }
  }
  
  deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
  }
  
  
  // MARK: Show and hide banner depending on reachability changes
  
  private func showBanner(duration: NSTimeInterval){
    
    // Show the view with animation
    bannerView.setupView(banner)
    view.addSubview(bannerView)
    
    UIView.animateWithDuration(0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.9,
                               initialSpringVelocity: 1,
                               options: [.AllowUserInteraction, .BeginFromCurrentState],
                               animations: {
                                self.bannerView.changeFrame(CGRectMake(0, 0, self.bannerWidth, self.bannerHeight))
      }, completion: { (done) in
        // Hide it after 2 sec
        NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(ReachabilityController.timerFinished(_:)), userInfo: true, repeats: false)
    })
    
    
  }
  
  @objc private func timerFinished(timer: NSTimer){
    timer.invalidate()
    hideBanner(true)
  }
  
  private func hideBanner(animated: Bool){
    if animated {
      UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: [.AllowUserInteraction, .BeginFromCurrentState], animations: { 
        self.bannerView.changeFrame(CGRectMake(0, 0, self.bannerWidth, 0))
        }, completion: { (ok) in
          self.bannerView.removeFromSuperview()
      })
    }else{
      bannerView.removeFromSuperview()
    }
  }
  
  @objc private func orientationChanged(notification: NSNotification){
    self.view.layoutIfNeeded()
  }
  
}

// MARK: - ReachabilityDelegate
// MARK: -
extension ReachabilityController: ReachabilityDelegate {
  public func reachabilityStatusChanged(status: NetworkStatus) {
    banner = ReachabilityBanner(status: status)
  }
}
