//
//  ReachabilityController.swift
//  Reachability
//
//  Created by Emile Décosterd on 31.07.16.
//  Copyright © 2016 Emile Décosterd. All rights reserved.
//

import UIKit

public final class ReachabilityController {
  
  // Reachability
  private var reachabilityManager: ReachabilityManager
  
  // The banner view and the corresponding model
  private let bannerView: ReachabilityBannerView
  private var banner: ReachabilityBanner!{
    didSet{
      print("Show banner should be executed")
      showBanner(3)
    }
  }
  private var bannerWidth: CGFloat {
    return UIScreen.mainScreen().bounds.size.width
  }
  private let bannerHeight = CGFloat(64)
  
  // The view in which the banner will be displayed
  private unowned var view: UIView
  
  public init(view: UIView){
    // Setup views
    self.view = view
    let bannerViewFrame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 0)
    bannerView = ReachabilityBannerView(frame: bannerViewFrame)
    
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
  
  public convenience init(view: UIView, wifiOnly: Bool){
    self.init(view:view)
    reachabilityManager.wifiOnly = true
  }
  
  deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
  }
  
  private func showBanner(duration: NSTimeInterval){
    bannerView.setupView(banner)
    bannerView.delegate = self
    
    // Show the view with animation
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

extension ReachabilityController: ReachabilityDelegate {
  public func reachabilityStatusChanged(status: NetworkStatus) {
    banner = ReachabilityBanner(status: status)
  }
}

extension ReachabilityController: ReachabilityBannerViewDelegate{
  func bannerViewDidPressHide() {
    hideBanner(true)
  }
}
