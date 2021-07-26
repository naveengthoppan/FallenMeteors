//
//  Date+Extension.swift
//  Fallen Meteors
//
//  Created by Naveen George Thoppan on 23/07/2021.
//

import Foundation

extension Date {

    func toString(format: String = "yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
