import Foundation

struct PasswordCalculator {
    private let calendar: Calendar

    init(calendar: Calendar = Calendar.current) {
        self.calendar = calendar
    }

    func startOfDay(for date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    func password(for date: Date, config: PasswordConfig) -> Int64 {
        let today = calendar.startOfDay(for: date)
        let initDay = calendar.startOfDay(for: config.initDay)
        let components = calendar.dateComponents([.day], from: initDay, to: today)
        let offset = max(components.day ?? 0, 0)
        return config.seed + Int64(offset)
    }
}
