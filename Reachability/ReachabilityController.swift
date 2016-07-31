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
  private var banner: ReachabilityBanner!
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
  }
  
  public convenience init(view: UIView, wifiOnly: Bool){
    self.init(view:view)
    reachabilityManager.wifiOnly = true
  }
  
  private func hideBanner(animated: Bool){
    if animated {
      UIView.animateWithDuration(5, animations: {
        self.bannerView.changeFrame(CGRectMake(0, 0, self.bannerWidth, 0))
        }, completion: { (ok) in
          self.bannerView.removeFromSuperview()
      })
    }else{
      bannerView.removeFromSuperview()
    }
  }
  
}

extension ReachabilityController: ReachabilityDelegate {
  func reachabilityStatusChanged(status: NetworkStatus) {
    banner = ReachabilityBanner(status: status)
    
    bannerView.setupView(banner)
    bannerView.delegate = self
    
    // Show the view with animation
    view.addSubview(bannerView)
    
    UIView.animateWithDuration(0.5) {
      self.bannerView.changeFrame(CGRectMake(0, 0, self.bannerWidth, self.bannerHeight))
    }
    
    // Hide it after 2 sec
    NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ReachabilityController.timerFinished(_:)), userInfo: true, repeats: false)
  }
  
  @objc private func timerFinished(timer: NSTimer){
    timer.invalidate()
    hideBanner(true)
  }
  
}

extension ReachabilityController: ReachabilityBannerViewDelegate{
  func bannerViewDidPressHide() {
    // Remove from superview
    hideBanner(false)
    self.bannerView.changeFrame(CGRectMake(0, 0, bannerWidth,0))
  }
}
