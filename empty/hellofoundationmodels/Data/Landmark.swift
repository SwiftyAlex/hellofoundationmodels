import Foundation
import FoundationModels

@Generable
struct FrenchGuide {
    @Guide(description: "A hint for what the user should visit first and why")
    let hint: String
    let landmarks: [Landmark]
}

@Generable
struct Landmark {
    let name: String
    let rating: Int
}
