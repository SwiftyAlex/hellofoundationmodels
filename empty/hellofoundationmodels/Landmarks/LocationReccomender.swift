import Foundation
import Observation
import FoundationModels

@MainActor
@Observable
final class LocationReccomender {
    private(set) var guide: FrenchGuide.PartiallyGenerated?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let session: LanguageModelSession

    init() {
        self.session = LanguageModelSession(
            instructions: Instructions {
                "You are a travel assistant who creates landmark guides for travel. You will provide up to five reccomendations."
            }
        )
        session.prewarm()
    }

    func recommend(for description: String) async {
        let trimmed = description.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            guide = nil
            errorMessage = "We need a location description to look up landmarks."
            return
        }

        isLoading = true
        errorMessage = nil
        guide = nil
        defer { isLoading = false }

        do {
            let stream = session.streamResponse(
                to: Prompt {
                    """
                    The user is planning a trip to \(trimmed). Provide up to five reccomendations.
                    """
                },
                generating: FrenchGuide.self,
                includeSchemaInPrompt: false,
                options: GenerationOptions(sampling: .greedy)
            )

            for try await partial in stream {
                try Task.checkCancellation()
                guide = partial.content
            }

        } catch is CancellationError {
            // Swallow cancellation without surfacing an error
            return
        } catch {
            print(session.transcript)
            errorMessage = error.localizedDescription
        }
    }
}
