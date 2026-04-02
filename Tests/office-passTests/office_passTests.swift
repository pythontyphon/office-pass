import Testing
import Foundation
@testable import office_pass

@Test func passwordMatchesSeedOnInitDay() {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "America/Los_Angeles")!

    let calculator = PasswordCalculator(calendar: calendar)
    let initDay = date(year: 2026, month: 4, day: 2, hour: 9, minute: 0, calendar: calendar)
    let config = PasswordConfig(seed: 123456789, initDay: initDay)

    let output = calculator.password(for: initDay, config: config)
    #expect(output == 123456789)
}

@Test func passwordIncrementsByOneEachDay() {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "America/Los_Angeles")!

    let calculator = PasswordCalculator(calendar: calendar)
    let initDay = date(year: 2026, month: 4, day: 2, hour: 8, minute: 0, calendar: calendar)
    let target = date(year: 2026, month: 4, day: 5, hour: 7, minute: 0, calendar: calendar)
    let config = PasswordConfig(seed: 123456789, initDay: initDay)

    let output = calculator.password(for: target, config: config)
    #expect(output == 123456792)
}

@Test func passwordHandlesDstTransitionByCalendarDay() {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "America/Los_Angeles")!

    let calculator = PasswordCalculator(calendar: calendar)
    let initDay = date(year: 2026, month: 3, day: 7, hour: 12, minute: 0, calendar: calendar)
    let target = date(year: 2026, month: 3, day: 10, hour: 1, minute: 0, calendar: calendar)
    let config = PasswordConfig(seed: 100, initDay: initDay)

    let output = calculator.password(for: target, config: config)
    #expect(output == 103)
}

@Test func passwordDoesNotGoBelowSeedWhenClockMovesBack() {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "America/Los_Angeles")!

    let calculator = PasswordCalculator(calendar: calendar)
    let initDay = date(year: 2026, month: 4, day: 10, hour: 9, minute: 0, calendar: calendar)
    let earlier = date(year: 2026, month: 4, day: 9, hour: 9, minute: 0, calendar: calendar)
    let config = PasswordConfig(seed: 5000, initDay: initDay)

    let output = calculator.password(for: earlier, config: config)
    #expect(output == 5000)
}

@Test func configStoreRoundTrip() throws {
    let tempBase = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let store = ConfigStore(baseDirectory: tempBase)
    let calendar = Calendar(identifier: .gregorian)
    let initDay = date(year: 2026, month: 4, day: 2, hour: 0, minute: 0, calendar: calendar)
    let expected = PasswordConfig(seed: 123456789, initDay: initDay)

    defer { try? FileManager.default.removeItem(at: tempBase) }

    try store.save(expected)
    let loaded = try store.load()

    #expect(loaded.seed == expected.seed)
    #expect(loaded.initDay == expected.initDay)
}

@Test func configStoreThrowsWhenMissing() {
    let tempBase = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let store = ConfigStore(baseDirectory: tempBase)

    defer { try? FileManager.default.removeItem(at: tempBase) }

    #expect(throws: OfficePassError.self) {
        _ = try store.load()
    }
}

private func date(year: Int, month: Int, day: Int, hour: Int, minute: Int, calendar: Calendar) -> Date {
    let components = DateComponents(
        calendar: calendar,
        timeZone: calendar.timeZone,
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute
    )
    return components.date!
}
