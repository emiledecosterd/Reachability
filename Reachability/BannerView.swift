//
//  ReachabilityBannerView.swift
//  Reachability
//
//  Created by Emile Décosterd on 31.07.16.
//  Copyright © 2016 Emile Décosterd. All rights reserved.
//

import UIKit

class BannerView: UIView {
  
  // GUI
  @IBOutlet var view: UIView!
  @IBOutlet weak var infoLabel: UILabel!
  
  // Properties
  var setup: Bool = false
  
  // Initialisation
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    NSBundle.mainBundle().loadNibNamed("BannerView", owner: self, options: nil)
    addSubview(self.view)
    self.view.layoutIfNeeded()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    NSBundle.mainBundle().loadNibNamed("BannerView", owner: self, options: nil)
    self.view.frame = frame
    addSubview(self.view)
    self.view.layoutIfNeeded()
  }
  
  convenience init(frame: CGRect, banner: ReachabilityBanner){
    self.init(frame: frame)
    setupView(banner)
  }
  
  // Setup
  
  func setupView(color: UIColor, message: String){
    
    view.backgroundColor = color
    infoLabel.text = message
    
    if !setup {
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
      self.setup = true
    }
    
  }
  
  // Functionality
  func changeFrame(frame: CGRect){
    self.frame = frame
    self.view.frame = frame
    self.view.layoutIfNeeded()
  }
  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    // Implement to draw a border
  }
  
}

extension BannerView{
  func setupView(banner: ReachabilityBanner){
    setupView(banner.color, message: banner.message)
  }
}