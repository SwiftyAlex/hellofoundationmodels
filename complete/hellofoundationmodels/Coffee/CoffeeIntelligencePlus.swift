import Foundation
import FoundationModels

@Observable
@MainActor
final class CoffeeIntelligencePlus {
    var session: LanguageModelSession

    private let coffeeTool: CoffeeToolPlus

    private(set) var reccomendation: CoffeeReccomendation.PartiallyGenerated?
    private var error: Error?

    init() {
        let coffeeTool = CoffeeToolPlus()

        self.session = LanguageModelSession(
            tools: [coffeeTool],
            instructions: Instructions {
                "Your job is to reccomend a coffee for the user, available at the shop Alex's Coffee."

                "You must take into account all details of their query, such as milk preference and taste, and create `CoffeeTag`s to provide to the tool."

                """
                Always use the coffeetoolplus tool to find coffees available at Alex's Coffee, to reccomend based on their query, as these are the ones we actually sell.
                """
        })

        self.coffeeTool = coffeeTool

        session.prewarm()
    }

    func generate(prompt: String) async throws {
        do {
            let stream = session.streamResponse(
                to: Prompt {
                   """
                   Use the coffeetool tool to find coffees to reccomend based on their query, which is below, as these are the ones we actually sell.
                   
                   Find a coffee for the user based on their query, which is below.
                   \(prompt)
                   """
                },
                generating: CoffeeReccomendation.self,
                includeSchemaInPrompt: false, options: GenerationOptions(sampling: .greedy)
            )

            for try await partialResponse in stream {
                reccomendation = partialResponse.content
            }

            for entry in session.transcript {
                print("===================")
                print(entry)
            }
        } catch {
            print(error.localizedDescription)
            print(error)
            self.error = error
        }
    }

}
