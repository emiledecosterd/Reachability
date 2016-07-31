//
//  String+EDE_additions.swift
//
//  Created by Emile Décosterd on 23.07.16.
//  Copyright © 2016 Emile Décosterd. All rights reserved.
//

import Foundation

extension String {
  
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
  
}