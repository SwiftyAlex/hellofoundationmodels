import SwiftUI
import FoundationModels


@Observable
class FormulaOneIntelligence {
    var stats: FormulaOneStats.PartiallyGenerated?
    private(set) var session: LanguageModelSession?
    private let tool = FormulaOneStatsTool()

    init() {
        session = .init(
            model: .default,
            tools: [tool],
            instructions: Instructions {
                """
                You will always use `formulaonetool` tool to get the current championship standings.
                """
            }
        )
    }

    func generate() async {
        guard let session else { return }
        guard !session.isResponding else { return }

        let stream = session.streamResponse(to: Prompt {
            """
            Summarize the top three in the championship, make sure to use `formulaonetool` to make a summary. Add detail and commentary if they're likely or not to win.
            """
        }, generating: FormulaOneStats.self)

        do {
            for try await result in stream {
                self.stats = result.content
            }
        } catch {
            print(error.localizedDescription)
        }

        print(session.transcript)
    }
}
