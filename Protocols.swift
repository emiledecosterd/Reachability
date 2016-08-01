//
//  Protocols.swift
//  Reachability
//
//  Created by Emile Décosterd on 31.07.16.
//  Copyright © 2016 Emile Décosterd. All rights reserved.
//

import Foundation

protocol Reachable {
  var reachability: AAPLReachability {get set}
}

public protocol ReachabilityDelegate {
  public func reachabilityStatusChanged(status: NetworkStatus)
}

