//
//  Day.swift
//  Telegrammer
//
//  Created by Givi on 18/03/2019.
//

import Foundation

public enum Day: Int {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    static var todayWeekDay: Day? {
        let todayDate = Date()
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return Day(rawValue: weekDay)
    }
}
