//
//  DonateViewController.swift
//  ACA Welcome
//
//  Created by Shaun Hubbard on 9/29/18.
//  Copyright © 2018 Shaun Hubbard. All rights reserved.
//

import UIKit
import Firebase

struct FirebaseConstants {
  private init() { }
  static let donateStart = "donateStart"
  static let donateCanceled = "donateCanceled"
  static let donateFinished = "donateFinished"
}

final class DonateViewController: BaseViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    Analytics.logEvent(FirebaseConstants.donateStart, parameters: nil)

    navigationItem.leftBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .cancel,
        target: self,
        action: #selector(cancel)
    )

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(done)
    )
  }
}

extension DonateViewController {
  @objc func cancel() {
    Analytics.logEvent(FirebaseConstants.donateCanceled, parameters: nil)
    navigationController?.dismiss(animated: true, completion: nil)
  }

  @objc func done() {
    Analytics.logEvent(FirebaseConstants.donateFinished, parameters: nil)
    navigationController?.dismiss(animated: true, completion: nil)
  }
}
