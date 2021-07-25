//
//  Date + extention.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 23/07/2021.
//

import Foundation

extension Date {
    /// Returns the amount of years from another date
    func getDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date) > 0 {
            return getDate(from: date)
        }
        
        if days(from: date) > 7 && days(from: date) < 365{
            return getDate(from: date)
        }

        if days(from: date) > 0 && days(from: date) < 8 {
            return " \(days(from: date)) days ago"
        }
        
        if hours(from: date) > 0 && hours(from: date)  < 24 {
            return " \(hours(from: date)) hours ago"
        }
        
        if minutes(from: date) > 0 && minutes(from: date) < 5 {
            return " \(minutes(from: date)) minutes ago"
        }
        
        return " Now"
    }
}
