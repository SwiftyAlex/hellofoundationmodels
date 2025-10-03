import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(content: {
                    NavigationLink(destination: LandmarkReccomendationView(), label: {
                        Text("Landmark Reccomendations")
                    })
                }, header: {
                    HStack {
                        Image("cb_paris")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                        Text("Landmarks")
                    }
                    .foregroundStyle(.secondary)
                    .font(.callout)
                })

                Section(content: {
                    NavigationLink(destination: SimpleCoffeeReccomendationView(), label: {
                        Text("Simple Coffee Reccomendation View")
                    })
                    NavigationLink(destination: CoffeeReccomendationView(), label: {
                        Text("Coffee Reccomendation View")
                    })
                }, header: {
                    HStack {
                        Image("cb_coffee")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                        Text("Coffee")
                    }
                    .foregroundStyle(.secondary)
                    .font(.callout)
                })

                Section(content: {
                    NavigationLink(destination: FormulaOneIntelligenceView(), label: {
                        Text("Formula One Stats")
                    })
                }, header: {
                    HStack {
                        Image("cb_helmet")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                        Text("Formula One")
                    }
                    .foregroundStyle(.secondary)
                    .font(.callout)
                })

                Section {
                    Text("lil' demo project by @SwiftyAlex. If you want to talk about foundation models, hit me up!")
                    Link(destination: URL(string: "https://x.com/swiftyalex")!, label: { Text("@SwiftyAlex on X") })
                }
            }
            .navigationTitle("Hello Foundation Models")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
