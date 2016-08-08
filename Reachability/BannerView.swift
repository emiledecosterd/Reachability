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
/// A class that represents a banner view. Can be animated by using the `changeFrame(_:)` method.
class BannerView: UIView {
  
  
  // MARK: GUI
  
  @IBOutlet private var view: UIView!
  @IBOutlet weak private var infoLabel: UILabel!
  
  
  // MARK: Initialisation
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
    self.view.frame = frame
  }
  
  /**
   * Instantiates a `BannerView` from the `ReachabilityBanner`.
   * - Parameter frame: The rectangle in which the view will be displayed
   * - Parameter banner: The model from which to configure the view.
  */
  convenience init(frame: CGRect, banner: ReachabilityBanner){
    self.init(frame: frame)
    setupView(banner)
  }
  
  
  // MARK: Setup
  
  private func configure(){
    
    // Load the nib file
    NSBundle.mainBundle().loadNibNamed("BannerView", owner: self, options: nil)
    addSubview(self.view)
    self.view.layoutIfNeeded()
    
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
  
  
  /**
   * Changes the view properties.
   * - Parameter color: The color the banner view should have.
   * - Parameter message: The text to be displayed in the view. Can be up to 2 lines.
  */
  func setupView(color: UIColor, message: String){
    view.backgroundColor = color
    infoLabel.text = message
  }
  
  
  // MARK: Frame 
  
  /**
   * Changes the view's frame. To be used in animations. Handles the resizing of the subviews.
   * - Parameter frame: The new rectangle in which the view should fit.
  */
  func changeFrame(frame: CGRect){
    self.frame = frame
    self.view.frame = frame
    self.view.layoutIfNeeded()
  }
  
}


// MARK: - Reachability extension
// MARK: -
extension BannerView{
  func setupView(banner: ReachabilityBanner){
    setupView(banner.color, message: banner.message)
  }
}