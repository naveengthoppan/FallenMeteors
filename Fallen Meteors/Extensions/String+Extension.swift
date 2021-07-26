//
//  String+Extension.swift
//  Fallen Meteors
//
//  Created by Naveen George Thoppan on 21/07/2021.
//

import Foundation

extension String {

    func toDate(withFormat format: String = "yyyy")-> Date?{

        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = format
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
         
        let date = RFC3339DateFormatter.date(from: self)

        return date

    }
}
