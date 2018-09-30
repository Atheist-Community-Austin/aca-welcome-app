//
//  Config.swift
//  ACA Welcome
//
//  Created by Shaun Hubbard on 9/29/18.
//  Copyright © 2018 Shaun Hubbard. All rights reserved.
//

import Foundation


let brainTreeClientToken: String = {
  #if DEBUG
  return "sandbox_zjfwy468_wv658f3ndg2d4m3m"
  #else
    fatalError("Get Token From John I")
  #endif
}()
