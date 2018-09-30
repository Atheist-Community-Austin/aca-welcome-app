//
//  WelcomeViewController.swift
//  ACA Welcome
//
//  Created by Shaun Hubbard on 9/29/18.
//  Copyright © 2018 Atheist Community of Austin Inc. All rights reserved.
//

import UIKit
import MaterialComponents
final class WelcomeViewController: UIViewController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  @IBOutlet weak var donateButton: MDCButton!
  @IBOutlet weak var volunteerButton: MDCButton!
  @IBOutlet weak var joinButton: MDCButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    [volunteerButton, joinButton, donateButton].compactMap { $0 }.forEach {
      MDCContainedButtonThemer.applyScheme(offWhiteButtonScheme, to: $0)
    }
  }
}

