//
//  Theme.swift
//  ACA Welcome
//
//  Created by Shaun Hubbard on 9/29/18.
//  Copyright © 2018 Atheist Community of Austin. All rights reserved.
//

import MaterialComponents

public let offWhiteButtonScheme: MDCButtonScheme = {
  let colorScheme = MDCSemanticColorScheme(defaults: .material201804)
  let offWhite = UIColor(named: "Off White") ?? .white
  colorScheme.primaryColor = offWhite
  let scheme = MDCButtonScheme()
  scheme.colorScheme = colorScheme
  return scheme
}()

