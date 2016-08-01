//
//  ReachabilityBannerView.swift
//  Reachability
//
//  Created by Emile Décosterd on 31.07.16.
//  Copyright © 2016 Emile Décosterd. All rights reserved.
//

import UIKit

protocol ReachabilityBannerViewDelegate {
  func bannerViewDidPressHide()
}

class ReachabilityBannerView: UIView {
  
  // Properties
  var delegate: ReachabilityBannerViewDelegate?
  
  // GUI
  @IBOutlet var view: UIView!
  @IBOutlet weak var statusInfoLabel: UILabel!
  @IBOutlet weak var hideButton: UIButton!
  
  
  // Initialisation
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    NSBundle.mainBundle().loadNibNamed("ReachabilityBannerView", owner: self, options: nil)
    addSubview(self.view)
    self.view.layoutIfNeeded()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    NSBundle.mainBundle().loadNibNamed("ReachabilityBannerView", owner: self, options: nil)
    self.view.frame = frame
    addSubview(self.view)
    self.view.layoutIfNeeded()
  }
  
  convenience init(frame: CGRect, banner: ReachabilityBanner){
    self.init(frame: frame)
    setupView(banner)
  }
  
  // Setup
  
  func setupView(banner: ReachabilityBanner){
    // Titles
    hideButton.titleLabel?.text = "Hide".localized
    view.backgroundColor = banner.color
    statusInfoLabel.text = banner.message
    
    // Blur effect
    let blurEffect = UIBlurEffect(style: .Light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.translatesAutoresizingMaskIntoConstraints = false
    view.insertSubview(blurView, atIndex: 0)
    
    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: blurView,
      attribute: .Height, relatedBy: .Equal, toItem: view,
      attribute: .Height, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: blurView,
      attribute: .Width, relatedBy: .Equal, toItem: view,
      attribute: .Width, multiplier: 1, constant: 0))
    view.addConstraints(constraints)
    
    self.autoresizingMask = [.FlexibleWidth, .FlexibleLeftMargin, .FlexibleRightMargin]
  }
  
  // Functionality
  func changeFrame(frame: CGRect){
    self.view.frame = frame
    self.view.layoutIfNeeded()
  }
  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    // Implement to draw a border
  }
  
  // Actions
  @IBAction func hide(sender: AnyObject) {
    print("Button pressed")
    delegate?.bannerViewDidPressHide()
  }
  
}