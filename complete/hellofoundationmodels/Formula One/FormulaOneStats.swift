import FoundationModels

@Generable
struct FormulaOneStats {
    @Guide(description: "A quick summary of the top three in the championship")
    let summary: String
    @Guide(description: "The top three drivers in the championship, sorted by points from top to bottom")
    let drivers: [FormulaOneDriver]
}

@Generable
struct FormulaOneDriver {
    @Guide(description: "The championship position of the driver")
    let position: Int
    @Guide(description: "The current championship points of the driver, higher is better")
    let points: Int
    let name: String
}
