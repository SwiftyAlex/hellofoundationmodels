import FoundationModels
import Foundation

@Observable
final class FormulaOneStatsTool: Tool {
    public let name = "formulaonetool"
    public let description = """
        Provides the current championship standings in Formula One
    """

    @Generable
    struct Arguments {
        let limit: Int
    }

    public init() { }

    public func call(arguments: Arguments) async throws -> [FormulaOneDriver] {
        await FormulaOneAPI.shared.fetchDrivers(limit: arguments.limit)
    }
}
