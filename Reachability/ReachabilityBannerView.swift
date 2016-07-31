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
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    NSBundle.mainBundle().loadNibNamed("ReachabilityBannerView", owner: self, options: nil)
    self.view.frame = frame
    addSubview(self.view)
  }
  
  convenience init(frame: CGRect, banner: ReachabilityBanner){
    self.init(frame: frame)
    setupView(banner)
  }
  
  // Setup
  
  func setupView(banner: ReachabilityBanner){
    hideButton.titleLabel?.text = "Hide".localized
    view.backgroundColor = banner.color
    statusInfoLabel.text = banner.message
  }
  
  // Functionality
  func changeFrame(frame: CGRect){
    self.view.frame = frame
  }
  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    // Implement to draw a border
  }
  
  // Actions
  @IBAction func hide(sender: AnyObject) {
    delegate?.bannerViewDidPressHide()
  }
  
}