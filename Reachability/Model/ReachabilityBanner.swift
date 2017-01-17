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


/// Helper class to enclose information corresponding to each `NetworkStatus` case
class ReachabilityBanner {
  
  var status: NetworkStatus
  
  var color: UIColor {
    switch status {
    case .notReachable: return UIColor.red
    case .cellular: return UIColor.orange
    case .wifi: return UIColor.green
    }
  }
  
  var message: String {
    switch status {
    case .notReachable: return "No network access! \nCheck your connection. ".localized
    case .cellular: return "Cellular connection \nThis can lead to additional costs.".localized
    case .wifi: return "Wifi connection".localized
    }
  }
  
  init(status: NetworkStatus){
    self.status = status
  }
  
}

