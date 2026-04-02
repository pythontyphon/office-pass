import Foundation

enum OfficePassError: Error {
    case invalidUsage
    case invalidSeed(String)
    case invalidDate(String)
    case notInitialized(String)
    case configCorrupted(String)
    case saveFailed(String)

    var description: String {
        switch self {
        case .invalidUsage:
            return "Invalid arguments."
        case .invalidSeed(let value):
            return "Seed must be a whole number. Received: \(value)."
        case .invalidDate(let value):
            return "Date must use YYYY-MM-DD format. Received: \(value)."
        case .notInitialized(let path):
            return "No configuration found at \(path). Run: office-pass --init <number>."
        case .configCorrupted(let path):
            return "Configuration at \(path) is corrupted. Re-run: office-pass --init <number>."
        case .saveFailed(let message):
            return "Failed to save configuration: \(message)."
        }
    }
}

struct PasswordConfig: Codable {
    let seed: Int64
    let initDay: Date
}

struct ConfigStore {
    private let fileManager: FileManager
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let baseDirectory: URL

    init(fileManager: FileManager = .default, baseDirectory: URL? = nil) {
        self.fileManager = fileManager
        self.baseDirectory = baseDirectory ?? fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("Application Support", isDirectory: true)
            .appendingPathComponent("office-pass", isDirectory: true)
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func load() throws -> PasswordConfig {
        let path = configPath()
        guard fileManager.fileExists(atPath: path.path) else {
            throw OfficePassError.notInitialized(path.path)
        }

        do {
            let data = try Data(contentsOf: path)
            return try decoder.decode(PasswordConfig.self, from: data)
        } catch {
            throw OfficePassError.configCorrupted(path.path)
        }
    }

    func save(_ config: PasswordConfig) throws {
        let path = configPath()
        do {
            try fileManager.createDirectory(
                at: path.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            let data = try encoder.encode(config)
            try data.write(to: path, options: .atomic)
        } catch {
            throw OfficePassError.saveFailed(error.localizedDescription)
        }
    }

    func configPath() -> URL {
        baseDirectory.appendingPathComponent("config.json")
    }
}
