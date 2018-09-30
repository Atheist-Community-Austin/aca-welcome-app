//
//  DonateViewController.swift
//  ACA Welcome
//
//  Created by Shaun Hubbard on 9/29/18.
//  Copyright © 2018 Shaun Hubbard. All rights reserved.
//

import UIKit
import Braintree
import BraintreeDropIn
import Firebase
import MaterialComponents

struct FirebaseConstants {
  private init() { }
  static let donateStart = "donateStart"
  static let donateViewCanceled = "donateViewCanceled"
  static let donateBrainTreeCanceled = "donateBrainTreeCanceled"
  static let donateFinished = "donateFinished"
}

final class DonateViewController: BaseViewController {
  @IBOutlet weak var donationAmountTextField: MDCTextInput!
  @IBOutlet weak var donatorTextField: MDCTextInput!

  var donationAmountTextFieldController: MDCTextInputControllerFloatingPlaceholder?
  var donatorTextFieldController: MDCTextInputControllerFloatingPlaceholder?

  override func viewDidLoad() {
    super.viewDidLoad()
    donationAmountTextFieldController = MDCTextInputControllerOutlined(textInput: donationAmountTextField as? UIView & MDCTextInput)
    donatorTextFieldController = MDCTextInputControllerOutlined(textInput: donatorTextField as? UIView & MDCTextInput)

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
    navigationItem.rightBarButtonItem?.isEnabled = false


    Analytics.logEvent(FirebaseConstants.donateStart, parameters: nil)
  }
}

extension DonateViewController {
  @objc func cancel() {
    Analytics.logEvent(FirebaseConstants.donateViewCanceled, parameters: nil)
    navigationController?.dismiss(animated: true, completion: nil)
  }

  @objc func done() {
    if validateEmail() {
      showCashRegister()
    } else {
      NSLog("Invalid Email")
    }
  }


  func showCashRegister() {
    let braintTreeRequest = BTDropInRequest()
    braintTreeRequest.amount = donationAmountTextField.text
    braintTreeRequest.shouldMaskSecurityCode = true
    guard let dropIn = BTDropInController(
      authorization: brainTreeClientToken,
      request: braintTreeRequest,
      handler: { [weak self] (controller, result, maybeError) in
      guard maybeError == nil else {
        self?.showError()
        return controller.dismiss(animated: true, completion: nil)
      }
        if result?.isCancelled == true {
          Analytics.logEvent(FirebaseConstants.donateBrainTreeCanceled, parameters: nil)
        } else {
          self?.finishedWithBraintreeSuccessfully()
        }
        controller.dismiss(animated: true, completion: nil)
    }) else { return }

    present(dropIn, animated: true, completion: nil)
  }

  func validateEmail() -> Bool {
    switch ValidateEmail(email: donatorTextField.text ?? "") {
    case .valid(_):
      return true
    case .invalid:
      let errorText = NSLocalizedString("Please leave blank or enter a valid email address",
                                        comment: "")
      donatorTextFieldController?.setErrorText(errorText,
                                               errorAccessibilityValue: errorText)
      return false
    case .blank:
      return true
    }
  }


  func finishedWithBraintreeSuccessfully() {
    Analytics.logEvent(FirebaseConstants.donateFinished, parameters: [AnalyticsParameterValue: Double(donatorTextField.text ?? "") ?? 0])
    navigationController?.dismiss(animated: true, completion: nil)
  }
}

extension DonateViewController: UITextFieldDelegate {

  @IBAction func didChange(_ textField: UITextField) {
    if donationAmountTextField as? UITextField == textField {
      switch DonationValidator(rawValue: textField.text ?? "") {
      case .amount:
        navigationItem.rightBarButtonItem?.isEnabled = true
      case .invalid:
        navigationItem.rightBarButtonItem?.isEnabled = false
      }

      donationAmountTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
    } else if donatorTextField as? UITextField == textField {
      donatorTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
    }
  }
}

enum DonationValidator {
  case invalid, amount(Double)
  init(rawValue: String) {
    guard let donation = Double(rawValue), donation >= 1.0 else {
      self = .invalid
      return
    }
    self = .amount(donation)
  }
}

enum ValidateEmail {
  static let regex: NSRegularExpression? = {
    let regexString = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
    return try? NSRegularExpression(pattern: regexString, options: .caseInsensitive)
  }()
  case blank
  case valid(String)
  case invalid

  init(email: String) {
    guard email.isPresent else {
      self = .blank
      return
    }
    let trimmedEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    guard ValidateEmail.regex?.firstMatch(in: trimmedEmail, options: [],
                                          range: NSRange(location: 0, length: email.count)) != nil
      else {
        self = .invalid
        return
    }
    self = .valid(trimmedEmail)
  }
}


extension BaseViewController {
  func showError() {
    let avc = UIAlertController(
      title: NSLocalizedString("Error", comment: ""),
      message: NSLocalizedString("Error with your session please check the internet connection and try again", comment: ""), preferredStyle: .alert)

    avc.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                style: .default, handler: nil))
    present(avc, animated: true, completion: nil)
  }
}
