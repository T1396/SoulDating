//
//  HeightExtensions.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 12.07.24.
//

import Foundation

//extension Measurement where UnitType == UnitLength {
//    func localized() -> String {
//        self.formatted()
//    }
//}
//
//
//extension Locale {
////    var usesMetricSystem: Bool {
////        self.measurementSystem == "Metric"
////    }
//
//    var measurementSystem: String {
//        if let system = (self as NSLocale).object(forKey: .measurementSystem) as? String {
//            return system
//        }
//        return "Metric" // Default to Metric if not found
//    }
//}
//
//extension Double {
//    func toLocalizedLength() -> String {
//        let locale = Locale.current
//        let measurement: Measurement<UnitLength>
//
//        if locale.usesMetricSystem {
//            measurement = Measurement(value: self, unit: UnitLength.kilometers)
//        } else {
//            let miles = self / 1.60934
//            measurement = Measurement(value: miles, unit: UnitLength.miles)
//        }
//
//        return measurement.formatted()
//    }
//
//    func localizedRadiusRange() -> ClosedRange<Double> {
//        let locale = Locale.current
//        if locale.usesMetricSystem {
//            return 10...400
//        } else {
//            return 10 / 1.60934...400 / 1.60934 // km to miles
//        }
//    }
//}
