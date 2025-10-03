import Foundation
import Observation
import FoundationModels
import CoreLocation

@MainActor
@Observable
final class LandmarkReccomenderPlus {
    private(set) var guide: FrenchGuide.PartiallyGenerated?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let session: LanguageModelSession

    init() {
        let tool = LandmarkTool()
        session = LanguageModelSession(
            tools: [tool],
            instructions: Instructions {
                "You are a travel guide that must use the landmarktool to plan visits around the user's current coordinates."
                "Always call landmarktool with the latitude and longitude you are given and copy its landmarks into the response."
                "Once you have the tool data, craft an energetic hint tailored to the place."
            }
        )
        session.prewarm()
    }

    func recommend(for location: CLLocationCoordinate2D, radiusMeters: Double? = nil) async {
        guide = nil
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let stream = session.streamResponse(
                to: Prompt {
                    """
                    The user is at latitude \(location.latitude) and longitude \(location.longitude).
                    Use landmarktool to fetch nearby points of interest within \(radiusMeters ?? 1_500) meters.
                    Return a friendly hint and the tool-provided landmarks.
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
            return
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
