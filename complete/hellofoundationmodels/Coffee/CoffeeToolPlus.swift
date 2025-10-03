import FoundationModels
import Foundation

@Observable
final class CoffeeToolPlus: Tool {
    public let name = "coffeetoolplus"
    public let description = "Provides coffee options available in our coffee shop for a set of tags."

    @Generable
    struct Arguments {
        @Guide(description: "The tags that will be used to find a coffee")
        var tags: [CoffeeTag]
    }

    public init() { }

    public func call(arguments: Arguments) async throws -> [Coffee] {
        let tags = arguments.tags
        return Coffee.all.filter { coffee in
            tags.contains(where: { coffee.tags.contains($0) })
        }
    }
}
