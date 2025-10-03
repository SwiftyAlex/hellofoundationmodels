import Foundation
import FoundationModels

@Observable
final class CoffeeTool: Tool {
    public let name = "coffeetool"
    public let description = "Provides coffee options available in our coffee shop."

    @Generable
    struct Arguments {
        @Guide(description: "The users original query")
        var naturalLanguageQuery: String
    }

    public init() { }

    public func call(arguments: Arguments) async throws -> [Coffee] {
        return Coffee.all
    }
}
