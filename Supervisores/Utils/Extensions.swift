//
//  Extensions.swift
//  Supervisores
//
//  Created by Sharepoint on 17/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let updateBlockInfo = Notification.Name("updateBlockInfo")
    static let hideBlockInfo = Notification.Name("hideBlockInfo")
    static let goToMapWithUnit = Notification.Name("goToMapWithUnit")
    static let bricksLoaded = Notification.Name("bricksLoaded")
    static let selectUnitInMap = Notification.Name("selectUnitInMap")
    static let closeDetailUnit = Notification.Name("closeDetailUnit")
    static  let hideKeyboard = Notification.Name("hideKeyboard")
    static let updateTrackingMode = Notification.Name("updateBlockInfo")
    static let showQR = Notification.Name("showQR")
    static let showDatePickerBereach = Notification.Name("showDatePickerBereach")
    static let showLevelBreach = Notification.Name("showLevelBreach")
    static let updateQuestionAswered = Notification.Name("updateQuestionAswered")
    static let showBreachReason = Notification.Name("showBreachReason")
    static let hideBreachReason = Notification.Name("hideBreachReason")
    static let showPauseReason = Notification.Name("showPauseReason")
    static let addBreach = Notification.Name("addinBreach")
    static let removeBreach = Notification.Name("removeBreach")
    static let tryingAddBreaches = Notification.Name("tryingAddBreaches")
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    func leftPadding(toLength: Int, withPad: String = " ") -> String {
        guard toLength > self.count else { return self }
        let padding = String(repeating: withPad, count: toLength - self.count)
        return padding + self
    }
}

