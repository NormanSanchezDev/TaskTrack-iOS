import Foundation

/**
 * Editable copy of a due date split into wheel components.
 * Changes stay here until the user confirms with Done.
 */
@Observable
final class DueDateDraft {
    var day: Int
    var month: Int {
        didSet { clampDay() }
    }
    var year: Int {
        didSet { clampDay() }
    }
    var hour: Int
    var minute: Int
    var second: Int

    let months = Array(1...12)
    let hours = Array(0...23)
    let minutesAndSeconds = Array(0...59)
    let years: [Int]

    private let calendar: Calendar

    init(date: Date, calendar: Calendar = .current) {
        self.calendar = calendar
        let parts = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: date)
        let currentYear = calendar.component(.year, from: .now)
        let selectedYear = parts.year ?? currentYear
        day = parts.day ?? 1
        month = parts.month ?? 1
        year = selectedYear
        hour = parts.hour ?? 0
        minute = parts.minute ?? 0
        second = parts.second ?? 0
        years = Array((min(currentYear, selectedYear) - 1)...(max(currentYear, selectedYear) + 10))
    }

    var days: [Int] {
        Array(1...daysInMonth)
    }

    var date: Date {
        let parts = DateComponents(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )
        return calendar.date(from: parts) ?? .now
    }

    private var daysInMonth: Int {
        let firstOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)) ?? .now
        return calendar.range(of: .day, in: .month, for: firstOfMonth)?.count ?? 31
    }

    private func clampDay() {
        day = min(day, daysInMonth)
    }
}
