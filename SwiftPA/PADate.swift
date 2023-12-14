//
//  PAScrollView.swift
//  SwiftPA
//
//  Created by 云天明 on 2023/12/14.
//

import UIKit

extension Date: PAExtensionWrappable {}

public extension PAExtensionNamespace where T == Date {
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(base)
    }
    
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(base)
    }
    
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(base)
    }
    
    var isThisYear: Bool {
        return Calendar.current.isDate(base, equalTo: Date(), toGranularity: .year)
    }
    
    var timeText: String {
        let relDF = DateFormatter()
        relDF.doesRelativeDateFormatting = true
        relDF.dateStyle = .medium
        relDF.timeStyle = .short

        let absDF = DateFormatter()
        absDF.dateStyle = .medium
        absDF.timeStyle = .short

        let rel = relDF.string(from: base)
        let abs = absDF.string(from: base)

        if (rel == abs) {
            let fullDF = DateFormatter()
            let space = -daySpace(Date())
            if space > 365 {
                fullDF.setLocalizedDateFormatFromTemplate("MMMdyjm")
            } else if space <= 7 {
                fullDF.setLocalizedDateFormatFromTemplate("EEEEjm")
            } else {
                fullDF.setLocalizedDateFormatFromTemplate("EEEMMMdjm")
            }
            return fullDF.string(from: base)
        } else {
            return rel
        }
    }
    
    func secondSpace(_ other: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: other, to: base).second ?? 0
    }
    
    func daySpace(_ other: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: other, to: base).day ?? 0
    }
    
}
