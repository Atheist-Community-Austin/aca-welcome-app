//
//  String.swift
//  ACA Welcome
//
//  Created by Shaun Hubbard on 9/29/18.
//  Copyright © 2018 Shaun Hubbard. All rights reserved.
//

import Foundation

extension String {
  /// A boolean test for if there are non whitespace characters present in a string
  public var isPresent: Bool {
    return !isBlank
  }

  /// A boolean test checking if a string is empty or nil
  public var isBlank: Bool {
    return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}
