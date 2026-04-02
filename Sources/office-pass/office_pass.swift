import Foundation

enum ExitCode {
    static let success: Int32 = 0
    static let usage: Int32 = 2
    static let runtimeError: Int32 = 1
}

@main
struct office_pass {
    static func main() {
        let args = Array(CommandLine.arguments.dropFirst())
        let store = ConfigStore()
        let calculator = PasswordCalculator()

        do {
            if args.isEmpty {
                let config = try store.load()
                let password = calculator.password(for: Date(), config: config)
                print(password)
                Foundation.exit(ExitCode.success)

            } else if args.count == 1 {
                if args[0] == "--help" || args[0] == "-h" {
                    printHelp()
                    Foundation.exit(ExitCode.success)
                }
                throw OfficePassError.invalidUsage

            } else if args.count == 2 {
                if args[0] == "--init" {
                    guard let seed = Int64(args[1]) else {
                        throw OfficePassError.invalidSeed(args[1])
                    }

                    let config = PasswordConfig(seed: seed, initDay: calculator.startOfDay(for: Date()))
                    try store.save(config)
                    print("Initialized office-pass with seed \(seed).")
                    Foundation.exit(ExitCode.success)
                }

                if args[0] == "--date" {
                    let requestedDate = try parseLocalDate(args[1])
                    let config = try store.load()
                    let password = calculator.password(for: requestedDate, config: config)
                    print(password)
                    Foundation.exit(ExitCode.success)
                }

                throw OfficePassError.invalidUsage
            } else {
                throw OfficePassError.invalidUsage
            }
        } catch let error as OfficePassError {
            fputs("Error: \(error.description)\n", stderr)
            if case .invalidUsage = error {
                printHelp(to: stderr)
                Foundation.exit(ExitCode.usage)
            }
            Foundation.exit(ExitCode.runtimeError)
        } catch {
            fputs("Error: \(error.localizedDescription)\n", stderr)
            Foundation.exit(ExitCode.runtimeError)
        }
    }
}

private func printHelp(to stream: UnsafeMutablePointer<FILE> = stdout) {
    let text = """
    office-pass
    Usage:
      office-pass
      office-pass --init <number>
      office-pass --date <YYYY-MM-DD>
      office-pass --help
    """
    fputs("\(text)\n", stream)
}

private func parseLocalDate(_ value: String) throws -> Date {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.isLenient = false

    guard let date = formatter.date(from: value) else {
        throw OfficePassError.invalidDate(value)
    }
    return date
}
