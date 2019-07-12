//
//  Extensions.swift
//  DB2LimitedTest
//
//  Created by md760 on 7/11/19.
//  Copyright © 2019 md760. All rights reserved.
///

import Foundation

extension Date {
    func getDateStringFromDate(_ dateFormat: String?) -> String {
        let dateFormatter = DateFormatter()
        if let format = dateFormat {
            dateFormatter.dateFormat = format
        } else {
            dateFormatter.dateFormat = "dd.MM.yyyy"
        }
        return dateFormatter.string(from: self)
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
