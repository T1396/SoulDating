import Foundation

extension Date {
    func toDateString(format: String = "dd.MM.yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    func toTimeString(format: String = "HH.mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    var isOlderThan30Days: Bool {
        let currentDate = Date()
        if let date30DaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: currentDate) {
            return self < date30DaysAgo
        }
        return false
    }
    
    func subtractYears(_ years: Int) -> Date {
        let eighteenYearsAgo = Calendar.current.date(byAdding: .year, value: -18 , to: self)
        return eighteenYearsAgo ?? Date()
    }
}
